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
#include <cstdio>
#include <cmath>

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
    this->irq_enable = 0;
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
            if (idx + 1 < TC_COLS)
                this->alpha[idx + 1] = (uint16_t)((tmp >> 16) & 0xFFFF);
        }
    } else {
        if (size == 2) {
            uint16_t tmp = this->alpha[idx];
            std::memcpy(data, &tmp, 2);
        } else {
            // 32-bit read: pack two halfwords when in range; zero-extend high
            // half when reading the last alpha so upper bits are never garbage
            uint32_t tmp = (uint32_t)this->alpha[idx];
            if (idx + 1 < TC_COLS)
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
            this->run_pipeline();
            this->status &= ~TC_STATUS_BUSY;
            this->status |= TC_STATUS_DONE;
            this->trace.msg(vp::Trace::LEVEL_INFO,
                "Pipeline done. Results: [%d %d %d %d]\n",
                this->result[0], this->result[1],
                this->result[2], this->result[3]);
        }
        this->irq_enable = (ctrl_val & TC_CTRL_IRQ_ENABLE) ? 1 : 0;
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
            if (val > TC_MAX_VECTOR_LEN) val = TC_MAX_VECTOR_LEN;
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
        if (is_write && size == 4)
            std::memcpy(&this->inv, data, 4);
        else if (!is_write && size == 4)
            std::memcpy(data, &this->inv, 4);
        return vp::IO_REQ_OK;
    }

    return vp::IO_REQ_INVALID;
}

// ---------------------------------------------------------------------------
// Act quant: q = round(clip(x * inv >> 15, -127, 127))
// Matches activation_quant.v (2-stage: multiply -> shift+round+clip)
// ---------------------------------------------------------------------------
static inline int8_t quantize_activation(int x, uint32_t inv)
{
    static constexpr int PRECISION = 15;
    static constexpr int Q_MAX = 127;
    static constexpr int Q_MIN = -127;

    int64_t product = (int64_t)x * (int64_t)(int32_t)(inv & 0x3FFFFF);
    int64_t round_amt = (int64_t)1 << (PRECISION - 1);
    int64_t biased = product + round_amt;
    int64_t shifted = biased >> PRECISION;

    if (shifted > Q_MAX) return Q_MAX;
    if (shifted < Q_MIN) return Q_MIN;
    return (int8_t)shifted;
}

// ---------------------------------------------------------------------------
// Run the full ternary GEMM pipeline
// ---------------------------------------------------------------------------
void TernarycoreDevice::run_pipeline()
{
    uint32_t vl = this->vector_len;
    if (vl == 0) return;

    // Stage 1: Quantize activations
    int8_t q[TC_MAX_VECTOR_LEN];
    for (uint32_t i = 0; i < vl; i++) {
        // Read as signed int8 (buffer stores raw bytes)
        int8_t act = (int8_t)this->act_buf[i];
        q[i] = quantize_activation(act, this->inv);
    }

    // Stage 2: Ternary GEMM — for each column, accumulate weighted activations
    // Weight buffer layout:
    //   wgt_buf[k] = {col3[k]:2, col2[k]:2, col1[k]:2, col0[k]:2}
    //   where bits 1:0 = col0, bits 3:2 = col1, bits 5:4 = col2, bits 7:6 = col3
    int32_t acc[TC_COLS] = {0};

    for (uint32_t k = 0; k < vl; k++) {
        uint8_t packed = this->wgt_buf[k];
        for (int c = 0; c < TC_COLS; c++) {
            uint8_t enc = (packed >> (2 * c)) & 0x3;
            int w = decode_weight(enc);
            if (w == +1) acc[c] += q[k];
            else if (w == -1) acc[c] -= q[k];
        }
    }

    // Stage 3: Scale multiply (matches ternary_scale.v)
    //   result = (acc * alpha + round) >> 15
    //   round = 1 if any of the lower 15 bits are set, else 0
    static constexpr int PRECISION = 15;
    for (int c = 0; c < TC_COLS; c++) {
        int64_t prod = (int64_t)acc[c] * (int64_t)(int32_t)(this->alpha[c] & 0xFFFF);
        uint32_t trunc = prod & ((1 << PRECISION) - 1);
        int round_bit = (trunc != 0) ? 1 : 0;
        int64_t shifted = prod >> PRECISION;
        this->result[c] = (int32_t)(shifted) + round_bit;
    }
}
