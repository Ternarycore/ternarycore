// SPDX-License-Identifier: CERN-OHL-S-2.0
// ternarycore_device.hpp
// GVSoC device model for the TernaryCore BitNet b1.58 GEMM accelerator.
//
// Memory-mapped register layout (32-bit aligned):
//   Offset    Name        Width  Access  Description
//   0x0000    ACT_BUF     VL*1   R/W     Activation buffer (1 byte per element)
//   0x0400    WGT_BUF     VL*4*  R/W     Weight buffer: 2-bit per weight,
//                           /8           packed 4 weights per byte, stored as
//                                        col0[k],col1[k],col2[k],col3[k] per byte
//   0x0800    ALPHA_0     16     R/W     Scale for column 0 (Q15, 1.0=0x8000)
//   0x0802    ALPHA_1     16     R/W     Scale for column 1
//   0x0804    ALPHA_2     16     R/W     Scale for column 2
//   0x0806    ALPHA_3     16     R/W     Scale for column 3
//   0x0808    RESULT_0    32     R       Result for column 0 (post-scale)
//   0x080C    RESULT_1    32     R       Result for column 1
//   0x0810    RESULT_2    32     R       Result for column 2
//   0x0814    RESULT_3    32     R       Result for column 3
//   0x0818    CTRL        32     W       Control: bit0=start, bit1=irq_enable
//   0x081C    STATUS      32     R       Status: bit0=busy, bit1=done
//   0x0820    VECTOR_LEN  32     R/W     Number of active elements (max 1024)
//   0x0824    INV         32     R/W     Inverse absmax for activation quant
//
// Total address range: 0x0000 - 0x0827 (max ~2KB)
//
// Algorithm (matches RTL ternary_pipeline.v):
//   1. For each of VECTOR_LEN activations: quantize to int8
//   2. For each column c: accumulate frac(activation[k] * weight[c][k])
//   3. For each column c: result = (acc * alpha[c] + round) >> 15

#ifndef __TERNARYCORE_DEVICE_HPP__
#define __TERNARYCORE_DEVICE_HPP__

#include <vp/vp.hpp>
#include <vp/itf/io.hpp>
#include <cstdint>
#include <cstring>

// Max supported vector length
static constexpr int TC_MAX_VECTOR_LEN = 1024;
static constexpr int TC_COLS = 4;

// Register offsets
static constexpr uint64_t TC_ACT_BUF      = 0x0000;
static constexpr uint64_t TC_ACT_BUF_SIZE = TC_MAX_VECTOR_LEN;
static constexpr uint64_t TC_WGT_BUF      = 0x0400;
static constexpr uint64_t TC_WGT_BUF_SIZE = TC_MAX_VECTOR_LEN;  // 4 cols × 2bit packed
static constexpr uint64_t TC_ALPHA_0      = 0x0800;
static constexpr uint64_t TC_ALPHA_1      = 0x0802;
static constexpr uint64_t TC_ALPHA_2      = 0x0804;
static constexpr uint64_t TC_ALPHA_3      = 0x0806;
static constexpr uint64_t TC_RESULT_0     = 0x0808;
static constexpr uint64_t TC_RESULT_1     = 0x080C;
static constexpr uint64_t TC_RESULT_2     = 0x0810;
static constexpr uint64_t TC_RESULT_3     = 0x0814;
static constexpr uint64_t TC_CTRL         = 0x0818;
static constexpr uint64_t TC_STATUS       = 0x081C;
static constexpr uint64_t TC_VECTOR_LEN   = 0x0820;
static constexpr uint64_t TC_INV          = 0x0824;
static constexpr uint64_t TC_ADDR_MAX     = 0x0828;

// CTRL bits
static constexpr uint32_t TC_CTRL_START      = 1 << 0;
static constexpr uint32_t TC_CTRL_IRQ_ENABLE = 1 << 1;

// STATUS bits
static constexpr uint32_t TC_STATUS_BUSY = 1 << 0;
static constexpr uint32_t TC_STATUS_DONE = 1 << 1;


class TernarycoreDevice : public vp::Component
{
public:
    TernarycoreDevice(vp::ComponentConf &config);

private:
    // IO port for memory-mapped register access
    vp::IoSlave io_itf;

    // Register / buffer storage
    uint8_t  act_buf[TC_MAX_VECTOR_LEN];       // Activation buffer
    uint8_t  wgt_buf[TC_MAX_VECTOR_LEN];        // Weight buffer (packed 2-bit per col per element)
    uint16_t alpha[TC_COLS];                    // Per-channel scales (Q15)
    int32_t  result[TC_COLS];                   // Computed results
    uint32_t vector_len;                         // Number of elements to process
    uint32_t inv;                                // Activation quantization parameter
    uint32_t status;                             // Status register
    uint32_t irq_enable;                         // IRQ enable flag

    vp::Trace trace;

    // IO request handler — called by the bus when the CPU accesses our address range
    static vp::IoReqStatus handle_req(vp::Block *__this, vp::IoReq *req);

    // Run the ternary GEMM pipeline (synchronous computation)
    void run_pipeline();

    // Decode a 2-bit weight encoding: 00=0, 01=+1, 10=-1
    static inline int decode_weight(uint8_t enc) {
        switch (enc) {
            case 0b01: return +1;
            case 0b10: return -1;
            default:   return  0;
        }
    }
};

#endif