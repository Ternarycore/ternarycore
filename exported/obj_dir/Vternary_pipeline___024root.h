// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vternary_pipeline.h for the primary calling header

#ifndef VERILATED_VTERNARY_PIPELINE___024ROOT_H_
#define VERILATED_VTERNARY_PIPELINE___024ROOT_H_  // guard

#include "verilated.h"


class Vternary_pipeline__Syms;

class alignas(VL_CACHE_LINE_BYTES) Vternary_pipeline___024root final {
  public:

    // DESIGN SPECIFIC STATE
    // Anonymous structures to workaround compiler member-count bugs
    struct {
        VL_IN8(clk,0,0);
        VL_IN8(rst_n,0,0);
        VL_IN8(valid_in,0,0);
        VL_IN8(activation,7,0);
        VL_IN8(weight_enc,7,0);
        VL_OUT8(valid_out,0,0);
        CData/*7:0*/ ternary_pipeline__DOT__q;
        CData/*0:0*/ ternary_pipeline__DOT__q_valid;
        CData/*7:0*/ ternary_pipeline__DOT__weight_enc_d1;
        CData/*0:0*/ ternary_pipeline__DOT__quant__DOT__product_valid;
        CData/*7:0*/ ternary_pipeline__DOT__gemm__DOT__dot_0__DOT__weighted;
        CData/*0:0*/ ternary_pipeline__DOT__gemm__DOT__dot_0__DOT__vector_done;
        CData/*0:0*/ ternary_pipeline__DOT__gemm__DOT__dot_0__DOT__vector_done_delayed;
        CData/*7:0*/ ternary_pipeline__DOT__gemm__DOT__dot_1__DOT__weighted;
        CData/*0:0*/ ternary_pipeline__DOT__gemm__DOT__dot_1__DOT__vector_done;
        CData/*0:0*/ ternary_pipeline__DOT__gemm__DOT__dot_1__DOT__vector_done_delayed;
        CData/*7:0*/ ternary_pipeline__DOT__gemm__DOT__dot_2__DOT__weighted;
        CData/*0:0*/ ternary_pipeline__DOT__gemm__DOT__dot_2__DOT__vector_done;
        CData/*0:0*/ ternary_pipeline__DOT__gemm__DOT__dot_2__DOT__vector_done_delayed;
        CData/*7:0*/ ternary_pipeline__DOT__gemm__DOT__dot_3__DOT__weighted;
        CData/*0:0*/ ternary_pipeline__DOT__gemm__DOT__dot_3__DOT__vector_done;
        CData/*0:0*/ ternary_pipeline__DOT__gemm__DOT__dot_3__DOT__vector_done_delayed;
        CData/*0:0*/ ternary_pipeline__DOT__scale__DOT__valid_d1;
        CData/*0:0*/ ternary_pipeline__DOT__scale__DOT__scale_ch__Vstatic__round;
        CData/*0:0*/ __VstlFirstIteration;
        CData/*0:0*/ __VstlPhaseResult;
        CData/*0:0*/ __Vtrigprevexpr___TOP__clk__0;
        CData/*0:0*/ __Vtrigprevexpr___TOP__rst_n__0;
        CData/*0:0*/ __VactPhaseResult;
        CData/*0:0*/ __VnbaPhaseResult;
        SData/*15:0*/ ternary_pipeline__DOT__scale__DOT__scale_ch__Vstatic__trunc;
        VL_IN(inv,21,0);
        VL_OUTW(result,127,0,4);
        VlWide<4>/*127:0*/ ternary_pipeline__DOT__gemm_result;
        IData/*29:0*/ ternary_pipeline__DOT__quant__DOT__product;
        IData/*31:0*/ ternary_pipeline__DOT__gemm__DOT____Vcellout__dot_0__acc_out;
        IData/*31:0*/ ternary_pipeline__DOT__gemm__DOT____Vcellout__dot_1__acc_out;
        IData/*31:0*/ ternary_pipeline__DOT__gemm__DOT____Vcellout__dot_2__acc_out;
        IData/*31:0*/ ternary_pipeline__DOT__gemm__DOT____Vcellout__dot_3__acc_out;
        IData/*31:0*/ ternary_pipeline__DOT__gemm__DOT__dot_0__DOT__weighted_ext;
        IData/*31:0*/ ternary_pipeline__DOT__gemm__DOT__dot_0__DOT__acc;
        IData/*31:0*/ ternary_pipeline__DOT__gemm__DOT__dot_0__DOT__count;
        IData/*31:0*/ ternary_pipeline__DOT__gemm__DOT__dot_0__DOT__result_latch;
        IData/*31:0*/ ternary_pipeline__DOT__gemm__DOT__dot_0__DOT__next_acc;
        IData/*31:0*/ ternary_pipeline__DOT__gemm__DOT__dot_1__DOT__weighted_ext;
        IData/*31:0*/ ternary_pipeline__DOT__gemm__DOT__dot_1__DOT__acc;
        IData/*31:0*/ ternary_pipeline__DOT__gemm__DOT__dot_1__DOT__count;
        IData/*31:0*/ ternary_pipeline__DOT__gemm__DOT__dot_1__DOT__result_latch;
        IData/*31:0*/ ternary_pipeline__DOT__gemm__DOT__dot_1__DOT__next_acc;
        IData/*31:0*/ ternary_pipeline__DOT__gemm__DOT__dot_2__DOT__weighted_ext;
        IData/*31:0*/ ternary_pipeline__DOT__gemm__DOT__dot_2__DOT__acc;
        IData/*31:0*/ ternary_pipeline__DOT__gemm__DOT__dot_2__DOT__count;
        IData/*31:0*/ ternary_pipeline__DOT__gemm__DOT__dot_2__DOT__result_latch;
        IData/*31:0*/ ternary_pipeline__DOT__gemm__DOT__dot_2__DOT__next_acc;
        IData/*31:0*/ ternary_pipeline__DOT__gemm__DOT__dot_3__DOT__weighted_ext;
        IData/*31:0*/ ternary_pipeline__DOT__gemm__DOT__dot_3__DOT__acc;
        IData/*31:0*/ ternary_pipeline__DOT__gemm__DOT__dot_3__DOT__count;
        IData/*31:0*/ ternary_pipeline__DOT__gemm__DOT__dot_3__DOT__result_latch;
        IData/*31:0*/ ternary_pipeline__DOT__gemm__DOT__dot_3__DOT__next_acc;
        IData/*31:0*/ ternary_pipeline__DOT__scale__DOT____VlemCall_3__scale_ch;
        IData/*31:0*/ ternary_pipeline__DOT__scale__DOT____VlemCall_2__scale_ch;
        IData/*31:0*/ ternary_pipeline__DOT__scale__DOT____VlemCall_1__scale_ch;
        IData/*31:0*/ ternary_pipeline__DOT__scale__DOT____VlemCall_0__scale_ch;
        IData/*31:0*/ __VactIterCount;
    };
    struct {
        VL_IN64(alpha,63,0);
        QData/*47:0*/ ternary_pipeline__DOT__scale__DOT__prod_0;
        QData/*47:0*/ ternary_pipeline__DOT__scale__DOT__prod_1;
        QData/*47:0*/ ternary_pipeline__DOT__scale__DOT__prod_2;
        QData/*47:0*/ ternary_pipeline__DOT__scale__DOT__prod_3;
        QData/*47:0*/ ternary_pipeline__DOT__scale__DOT__scale_ch__Vstatic__shifted;
        VlUnpacked<QData/*63:0*/, 1> __VstlTriggered;
        VlUnpacked<QData/*63:0*/, 1> __VactTriggered;
        VlUnpacked<QData/*63:0*/, 1> __VnbaTriggered;
    };

    // INTERNAL VARIABLES
    Vternary_pipeline__Syms* vlSymsp;
    const char* vlNamep;

    // CONSTRUCTORS
    Vternary_pipeline___024root(Vternary_pipeline__Syms* symsp, const char* namep);
    ~Vternary_pipeline___024root();
    VL_UNCOPYABLE(Vternary_pipeline___024root);

    // INTERNAL METHODS
    void __Vconfigure(bool first);
};


#endif  // guard
