// SPDX-License-Identifier: CERN-OHL-S-2.0
// ternarycore_device.cpp
// GVSoC device model implementation for the TernaryCore BitNet b1.58 GEMM accelerator.
//
// This device model implements the exact same pipeline logic as the RTL
// (ternary_pipeline.v), exposed as a PULP memory-mapped accelerator.
//
// Pipeline stages (all synchronous, run on "start"):
//   1. Activation quantization: q = round(clip(x * inv >> 15, -127, 127))
//   2. Ternary GEMM: for each column c, acc[c] = sum(activation[k] * weight[c][k])
//   3. Scale: result[c] = (acc[c] * alpha[c] + rounding) >> 15

#include "ternarycore_device.hpp"

// ---------------------------------------------------------------------------
// gvsoc entry point — the framework calls this to instantiate the device
// ---------------------------------------------------------------------------
extern "C" vp::Component *gv_new(vp::ComponentConf &config)
{
    return new TernarycoreDevice(config);
}

// ---------------------------------------------------------------------------
// Constructor: register IO port, init registers
// ---------------------------------------------------------------------------
TernarycoreDevice::TernarycoreDevice(vp::ComponentConf &config)
    : vp::Component(config)
{
    // Register the IO slave port. The PULP cluster bus binds to this name.
    this->io_itf.set_req_meth(&TernarycoreDevice::handle_req);
    this->new_slave_port("io_itf", &this->io_itf);

    // Create a trace channel for debug logging
    this->traces.new_trace("trace", &this->trace, vp::DEBUG);

    // Initialize internal state
    this->status = 0;
    this->vector_len = 0;
    this->inv = 0;
    std::memset(this->act_buf, 0, sizeof(this->act_buf));
    std::memset(this->wgt_buf, 0, sizeof(this->wgt_buf));
    std::memset(this->alpha, 0, sizeof(this->alpha));
    std::memset(this->result, 0, sizeof(this->result));

    this->trace.msg(vp::Trace::LEVEL_INFO, "TernaryCore device created\n");
}

// ---------------------------------------------------------------------------
// IO request handler — called by the PULP bus on every access to our range
// ---------------------------------------------------------------------------
vp::IoReqStatus TernarycoreDevice::handle_req(vp::Block *__this, vp::IoReq *req)
{
    TernarycoreDevice *self = (TernarycoreDevice *)__this;
    uint64_t addr = req->get_addr();
    uint64_t size = req->get_size();

    // TC_ADDR_MAX is exclusive. Avoid addr+size overflow while rejecting
    // zero-length and partially out-of-range transactions.
    if (size == 0 || addr >= TC_ADDR_MAX || size > TC_ADDR_MAX - addr) {
        self->trace.msg(vp::Trace::LEVEL_WARNING,
            "Access out of range: addr=0x%lx size=%lu\n", addr, size);
        return vp::IO_REQ_INVALID;
    }

    // Dispatch to region-specific handler
    if (addr >= TC_ACT_BUF && addr < TC_ACT_BUF + TC_ACT_BUF_SIZE)
        return self->handle_act_buf(req);

    if (addr >= TC_WGT_BUF && addr < TC_WGT_BUF + TC_WGT_BUF_SIZE)
        return self->handle_wgt_buf(req);

    if (addr >= TC_ALPHA_0 && addr < TC_ALPHA_0 + TC_COLS * 2)
        return self->handle_alpha(req);

    // Result, CTRL, STATUS, VECTOR_LEN, INV at fixed addresses
    return self->handle_register(addr, req);
}

vp::IoReqStatus TernarycoreDevice::handle_act_buf(vp::IoReq *req)
{
    uint64_t offset = req->get_addr() - TC_ACT_BUF;
    uint8_t *data = req->get_data();
    uint64_t size = req->get_size();
    if (size > TC_ACT_BUF_SIZE - offset) {
        this->trace.msg(vp::Trace::LEVEL_WARNING,
            "Activation buffer access out of bounds: offset=%lu size=%lu (buffer=%u)\n",
            offset, size, TC_ACT_BUF_SIZE);
        return vp::IO_REQ_INVALID;
    }
    if (req->get_is_write())
        std::memcpy(&this->act_buf[offset], data, size);
    else
        std::memcpy(data, &this->act_buf[offset], size);
    return vp::IO_REQ_OK;
}

vp::IoReqStatus TernarycoreDevice::handle_wgt_buf(vp::IoReq *req)
{
    uint64_t offset = req->get_addr() - TC_WGT_BUF;
    uint8_t *data = req->get_data();
    uint64_t size = req->get_size();
    if (size > TC_WGT_BUF_SIZE - offset) {
        this->trace.msg(vp::Trace::LEVEL_WARNING,
            "Weight buffer access out of bounds: offset=%lu size=%lu (buffer=%u)\n",
            offset, size, TC_WGT_BUF_SIZE);
        return vp::IO_REQ_INVALID;
    }
    if (req->get_is_write())
        std::memcpy(&this->wgt_buf[offset], data, size);
    else
        std::memcpy(data, &this->wgt_buf[offset], size);
    return vp::IO_REQ_OK;
}

vp::IoReqStatus TernarycoreDevice::handle_alpha(vp::IoReq *req)
{
    uint64_t addr = req->get_addr();
    int idx = (addr - TC_ALPHA_0) / 2;
    uint8_t *data = req->get_data();
    uint64_t size = req->get_size();
    bool is_write = req->get_is_write();

    // Alpha registers are 16-bit; only 2- and 4-byte accesses are supported.
    // Use memcpy for all R/W to avoid unaligned pointer casts.
    if (idx < 0 || idx >= TC_COLS)
        return vp::IO_REQ_INVALID;
    if (size != 2 && size != 4)
        return vp::IO_REQ_INVALID;
    // Require halfword alignment for alpha MMIO
    if ((addr - TC_ALPHA_0) & 1)
        return vp::IO_REQ_INVALID;

    if (size == 4 && idx + 1 >= TC_COLS)
        return vp::IO_REQ_INVALID;

    if (is_write) {
        if (size == 2) {
            uint16_t tmp;
            std::memcpy(&tmp, data, 2);
            this->alpha[idx] = tmp;
        } else {
            // 32-bit write: low half -> alpha[idx], high half -> next (if any)
            uint32_t tmp;
            std::memcpy(&tmp, data, 4);
            this->alpha[idx] = (uint16_t)(tmp & 0xFFFF);
            this->alpha[idx + 1] = (uint16_t)((tmp >> 16) & 0xFFFF);
        }
    } else {
        if (size == 2) {
            uint16_t tmp = this->alpha[idx];
            std::memcpy(data, &tmp, 2);
        } else {
            // 32-bit read: pack two adjacent halfwords.
            uint32_t tmp = (uint32_t)this->alpha[idx];
            tmp |= (uint32_t)this->alpha[idx + 1] << 16;
            std::memcpy(data, &tmp, 4);
        }
    }
    return vp::IO_REQ_OK;
}

vp::IoReqStatus TernarycoreDevice::handle_register(uint64_t addr, vp::IoReq *req)
{
    uint8_t *data = req->get_data();
    uint64_t size = req->get_size();
    bool is_write = req->get_is_write();

    // Result registers (read-only, 32-bit each)
    if (addr >= TC_RESULT_0 && addr < TC_RESULT_0 + TC_COLS * 4) {
        if (is_write || size != 4 || ((addr - TC_RESULT_0) & 3))
            return vp::IO_REQ_INVALID;
        int idx = (addr - TC_RESULT_0) / 4;
        uint32_t tmp = (uint32_t)this->result[idx];
        std::memcpy(data, &tmp, 4);
        return vp::IO_REQ_OK;
    }

    // CTRL register (write-only)
    if (addr == TC_CTRL) {
        if (!is_write || size != 4)
            return vp::IO_REQ_INVALID;
        uint32_t ctrl_val;
        std::memcpy(&ctrl_val, data, 4);
        if (ctrl_val & TC_CTRL_START) {
            this->trace.msg(vp::Trace::LEVEL_INFO,
                "Starting pipeline (vector_len=%u, inv=%u)\n",
                this->vector_len, this->inv);
            this->status |= TC_STATUS_BUSY;
            this->status &= ~TC_STATUS_DONE;
            if (!this->run_pipeline()) {
                this->status &= ~(TC_STATUS_BUSY | TC_STATUS_DONE);
                this->trace.msg(vp::Trace::LEVEL_WARNING,
                    "Rejected pipeline start with vector_len=%u\n",
                    this->vector_len);
                return vp::IO_REQ_INVALID;
            }
            this->status &= ~TC_STATUS_BUSY;
            this->status |= TC_STATUS_DONE;
            this->trace.msg(vp::Trace::LEVEL_INFO,
                "Pipeline done. Results: [%d %d %d %d]\n",
                this->result[0], this->result[1],
                this->result[2], this->result[3]);
        }
        return vp::IO_REQ_OK;
    }

    // STATUS register (read-only, supports 1/2/4 byte reads)
    if (addr == TC_STATUS) {
        if (is_write || (size != 1 && size != 2 && size != 4))
            return vp::IO_REQ_INVALID;
        if (size == 4) {
            uint32_t tmp = this->status;
            std::memcpy(data, &tmp, 4);
        } else if (size == 2) {
            uint16_t tmp = (uint16_t)this->status;
            std::memcpy(data, &tmp, 2);
        } else {
            uint8_t tmp = (uint8_t)this->status;
            std::memcpy(data, &tmp, 1);
        }
        return vp::IO_REQ_OK;
    }

    // VECTOR_LEN register
    if (addr == TC_VECTOR_LEN) {
        if (size != 4)
            return vp::IO_REQ_INVALID;
        if (is_write && size == 4) {
            uint32_t val;
            std::memcpy(&val, data, 4);
            if (val > TC_MAX_VECTOR_LEN)
                return vp::IO_REQ_INVALID;
            this->vector_len = val;
        } else if (!is_write && size == 4) {
            uint32_t tmp = this->vector_len;
            std::memcpy(data, &tmp, 4);
        }
        return vp::IO_REQ_OK;
    }

    // INV register
    if (addr == TC_INV) {
        if (size != 4)
            return vp::IO_REQ_INVALID;
        if (is_write && size == 4) {
            uint32_t value;
            std::memcpy(&value, data, 4);
            this->inv = value & ((1u << ternarycore::INV_WIDTH) - 1);
        }
        else if (!is_write && size == 4)
            std::memcpy(data, &this->inv, 4);
        return vp::IO_REQ_OK;
    }

    return vp::IO_REQ_INVALID;
}

// ---------------------------------------------------------------------------
// Run the full ternary GEMM pipeline
// ---------------------------------------------------------------------------
bool TernarycoreDevice::run_pipeline()
{
    return ternarycore::run_pipeline(
        this->act_buf, this->wgt_buf, this->alpha, this->vector_len,
        TC_COLS, this->inv, this->result);
}
