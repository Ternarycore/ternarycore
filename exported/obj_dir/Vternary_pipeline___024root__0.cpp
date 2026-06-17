// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vternary_pipeline.h for the primary calling header

#include "Vternary_pipeline__pch.h"

void Vternary_pipeline___024root___eval_triggers_vec__act(Vternary_pipeline___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vternary_pipeline___024root___eval_triggers_vec__act\n"); );
    Vternary_pipeline__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.__VactTriggered[0U] = (QData)((IData)(
                                                    ((((~ (IData)(vlSelfRef.rst_n)) 
                                                       & (IData)(vlSelfRef.__Vtrigprevexpr___TOP__rst_n__0)) 
                                                      << 1U) 
                                                     | ((IData)(vlSelfRef.clk) 
                                                        & (~ (IData)(vlSelfRef.__Vtrigprevexpr___TOP__clk__0))))));
    vlSelfRef.__Vtrigprevexpr___TOP__clk__0 = vlSelfRef.clk;
    vlSelfRef.__Vtrigprevexpr___TOP__rst_n__0 = vlSelfRef.rst_n;
}

bool Vternary_pipeline___024root___trigger_anySet__act(const VlUnpacked<QData/*63:0*/, 1> &in) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vternary_pipeline___024root___trigger_anySet__act\n"); );
    // Locals
    IData/*31:0*/ n;
    // Body
    n = 0U;
    do {
        if (in[n]) {
            return (1U);
        }
        n = ((IData)(1U) + n);
    } while ((1U > n));
    return (0U);
}

void Vternary_pipeline___024root___nba_sequent__TOP__0(Vternary_pipeline___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vternary_pipeline___024root___nba_sequent__TOP__0\n"); );
    Vternary_pipeline__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    QData/*47:0*/ __Vfunc_ternary_pipeline__DOT__scale__DOT__scale_ch__0__p;
    __Vfunc_ternary_pipeline__DOT__scale__DOT__scale_ch__0__p = 0;
    QData/*47:0*/ __Vfunc_ternary_pipeline__DOT__scale__DOT__scale_ch__1__p;
    __Vfunc_ternary_pipeline__DOT__scale__DOT__scale_ch__1__p = 0;
    QData/*47:0*/ __Vfunc_ternary_pipeline__DOT__scale__DOT__scale_ch__2__p;
    __Vfunc_ternary_pipeline__DOT__scale__DOT__scale_ch__2__p = 0;
    QData/*47:0*/ __Vfunc_ternary_pipeline__DOT__scale__DOT__scale_ch__3__p;
    __Vfunc_ternary_pipeline__DOT__scale__DOT__scale_ch__3__p = 0;
    CData/*0:0*/ __Vdly__ternary_pipeline__DOT__gemm__DOT__dot_0__DOT__vector_done;
    __Vdly__ternary_pipeline__DOT__gemm__DOT__dot_0__DOT__vector_done = 0;
    IData/*31:0*/ __Vdly__ternary_pipeline__DOT__gemm__DOT__dot_0__DOT__count;
    __Vdly__ternary_pipeline__DOT__gemm__DOT__dot_0__DOT__count = 0;
    CData/*0:0*/ __Vdly__ternary_pipeline__DOT__gemm__DOT__dot_1__DOT__vector_done;
    __Vdly__ternary_pipeline__DOT__gemm__DOT__dot_1__DOT__vector_done = 0;
    IData/*31:0*/ __Vdly__ternary_pipeline__DOT__gemm__DOT__dot_1__DOT__count;
    __Vdly__ternary_pipeline__DOT__gemm__DOT__dot_1__DOT__count = 0;
    CData/*0:0*/ __Vdly__ternary_pipeline__DOT__gemm__DOT__dot_2__DOT__vector_done;
    __Vdly__ternary_pipeline__DOT__gemm__DOT__dot_2__DOT__vector_done = 0;
    IData/*31:0*/ __Vdly__ternary_pipeline__DOT__gemm__DOT__dot_2__DOT__count;
    __Vdly__ternary_pipeline__DOT__gemm__DOT__dot_2__DOT__count = 0;
    CData/*0:0*/ __Vdly__ternary_pipeline__DOT__gemm__DOT__dot_3__DOT__vector_done;
    __Vdly__ternary_pipeline__DOT__gemm__DOT__dot_3__DOT__vector_done = 0;
    IData/*31:0*/ __Vdly__ternary_pipeline__DOT__gemm__DOT__dot_3__DOT__count;
    __Vdly__ternary_pipeline__DOT__gemm__DOT__dot_3__DOT__count = 0;
    // Body
    __Vdly__ternary_pipeline__DOT__gemm__DOT__dot_1__DOT__vector_done 
        = vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_1__DOT__vector_done;
    __Vdly__ternary_pipeline__DOT__gemm__DOT__dot_1__DOT__count 
        = vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_1__DOT__count;
    __Vdly__ternary_pipeline__DOT__gemm__DOT__dot_2__DOT__vector_done 
        = vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_2__DOT__vector_done;
    __Vdly__ternary_pipeline__DOT__gemm__DOT__dot_2__DOT__count 
        = vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_2__DOT__count;
    __Vdly__ternary_pipeline__DOT__gemm__DOT__dot_3__DOT__vector_done 
        = vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_3__DOT__vector_done;
    __Vdly__ternary_pipeline__DOT__gemm__DOT__dot_3__DOT__count 
        = vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_3__DOT__count;
    __Vdly__ternary_pipeline__DOT__gemm__DOT__dot_0__DOT__vector_done 
        = vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_0__DOT__vector_done;
    __Vdly__ternary_pipeline__DOT__gemm__DOT__dot_0__DOT__count 
        = vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_0__DOT__count;
    vlSelfRef.valid_out = ((IData)(vlSelfRef.rst_n) 
                           && (IData)(vlSelfRef.ternary_pipeline__DOT__scale__DOT__valid_d1));
    if (vlSelfRef.rst_n) {
        if (vlSelfRef.ternary_pipeline__DOT__scale__DOT__valid_d1) {
            __Vfunc_ternary_pipeline__DOT__scale__DOT__scale_ch__0__p 
                = vlSelfRef.ternary_pipeline__DOT__scale__DOT__prod_0;
            vlSelfRef.ternary_pipeline__DOT__scale__DOT__scale_ch__Vstatic__trunc 
                = (0x0000ffffU & (IData)(__Vfunc_ternary_pipeline__DOT__scale__DOT__scale_ch__0__p));
            vlSelfRef.ternary_pipeline__DOT__scale__DOT__scale_ch__Vstatic__round 
                = (0U != (IData)(vlSelfRef.ternary_pipeline__DOT__scale__DOT__scale_ch__Vstatic__trunc));
            vlSelfRef.ternary_pipeline__DOT__scale__DOT__scale_ch__Vstatic__shifted 
                = VL_SHIFTR_QQI(48,48,32, __Vfunc_ternary_pipeline__DOT__scale__DOT__scale_ch__0__p, 0x0000000fU);
            vlSelfRef.ternary_pipeline__DOT__scale__DOT____VlemCall_0__scale_ch 
                = ((IData)(vlSelfRef.ternary_pipeline__DOT__scale__DOT__scale_ch__Vstatic__shifted) 
                   + (IData)(vlSelfRef.ternary_pipeline__DOT__scale__DOT__scale_ch__Vstatic__round));
            vlSelfRef.result[0U] = vlSelfRef.ternary_pipeline__DOT__scale__DOT____VlemCall_0__scale_ch;
            __Vfunc_ternary_pipeline__DOT__scale__DOT__scale_ch__1__p 
                = vlSelfRef.ternary_pipeline__DOT__scale__DOT__prod_1;
            vlSelfRef.ternary_pipeline__DOT__scale__DOT__scale_ch__Vstatic__trunc 
                = (0x0000ffffU & (IData)(__Vfunc_ternary_pipeline__DOT__scale__DOT__scale_ch__1__p));
            vlSelfRef.ternary_pipeline__DOT__scale__DOT__scale_ch__Vstatic__round 
                = (0U != (IData)(vlSelfRef.ternary_pipeline__DOT__scale__DOT__scale_ch__Vstatic__trunc));
            vlSelfRef.ternary_pipeline__DOT__scale__DOT__scale_ch__Vstatic__shifted 
                = VL_SHIFTR_QQI(48,48,32, __Vfunc_ternary_pipeline__DOT__scale__DOT__scale_ch__1__p, 0x0000000fU);
            vlSelfRef.ternary_pipeline__DOT__scale__DOT____VlemCall_1__scale_ch 
                = ((IData)(vlSelfRef.ternary_pipeline__DOT__scale__DOT__scale_ch__Vstatic__shifted) 
                   + (IData)(vlSelfRef.ternary_pipeline__DOT__scale__DOT__scale_ch__Vstatic__round));
            vlSelfRef.result[1U] = vlSelfRef.ternary_pipeline__DOT__scale__DOT____VlemCall_1__scale_ch;
            __Vfunc_ternary_pipeline__DOT__scale__DOT__scale_ch__2__p 
                = vlSelfRef.ternary_pipeline__DOT__scale__DOT__prod_2;
            vlSelfRef.ternary_pipeline__DOT__scale__DOT__scale_ch__Vstatic__trunc 
                = (0x0000ffffU & (IData)(__Vfunc_ternary_pipeline__DOT__scale__DOT__scale_ch__2__p));
            vlSelfRef.ternary_pipeline__DOT__scale__DOT__scale_ch__Vstatic__round 
                = (0U != (IData)(vlSelfRef.ternary_pipeline__DOT__scale__DOT__scale_ch__Vstatic__trunc));
            vlSelfRef.ternary_pipeline__DOT__scale__DOT__scale_ch__Vstatic__shifted 
                = VL_SHIFTR_QQI(48,48,32, __Vfunc_ternary_pipeline__DOT__scale__DOT__scale_ch__2__p, 0x0000000fU);
            vlSelfRef.ternary_pipeline__DOT__scale__DOT____VlemCall_2__scale_ch 
                = ((IData)(vlSelfRef.ternary_pipeline__DOT__scale__DOT__scale_ch__Vstatic__shifted) 
                   + (IData)(vlSelfRef.ternary_pipeline__DOT__scale__DOT__scale_ch__Vstatic__round));
            vlSelfRef.result[2U] = vlSelfRef.ternary_pipeline__DOT__scale__DOT____VlemCall_2__scale_ch;
            __Vfunc_ternary_pipeline__DOT__scale__DOT__scale_ch__3__p 
                = vlSelfRef.ternary_pipeline__DOT__scale__DOT__prod_3;
            vlSelfRef.ternary_pipeline__DOT__scale__DOT__scale_ch__Vstatic__trunc 
                = (0x0000ffffU & (IData)(__Vfunc_ternary_pipeline__DOT__scale__DOT__scale_ch__3__p));
            vlSelfRef.ternary_pipeline__DOT__scale__DOT__scale_ch__Vstatic__round 
                = (0U != (IData)(vlSelfRef.ternary_pipeline__DOT__scale__DOT__scale_ch__Vstatic__trunc));
            vlSelfRef.ternary_pipeline__DOT__scale__DOT__scale_ch__Vstatic__shifted 
                = VL_SHIFTR_QQI(48,48,32, __Vfunc_ternary_pipeline__DOT__scale__DOT__scale_ch__3__p, 0x0000000fU);
            vlSelfRef.ternary_pipeline__DOT__scale__DOT____VlemCall_3__scale_ch 
                = ((IData)(vlSelfRef.ternary_pipeline__DOT__scale__DOT__scale_ch__Vstatic__shifted) 
                   + (IData)(vlSelfRef.ternary_pipeline__DOT__scale__DOT__scale_ch__Vstatic__round));
            vlSelfRef.result[3U] = vlSelfRef.ternary_pipeline__DOT__scale__DOT____VlemCall_3__scale_ch;
        }
        vlSelfRef.ternary_pipeline__DOT__gemm__DOT____Vcellout__dot_1__acc_out 
            = ((IData)(vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_1__DOT__vector_done)
                ? vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_1__DOT__result_latch
                : 0U);
        vlSelfRef.ternary_pipeline__DOT__gemm__DOT____Vcellout__dot_2__acc_out 
            = ((IData)(vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_2__DOT__vector_done)
                ? vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_2__DOT__result_latch
                : 0U);
        vlSelfRef.ternary_pipeline__DOT__gemm__DOT____Vcellout__dot_3__acc_out 
            = ((IData)(vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_3__DOT__vector_done)
                ? vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_3__DOT__result_latch
                : 0U);
        if (vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_0__DOT__vector_done) {
            vlSelfRef.ternary_pipeline__DOT__gemm__DOT____Vcellout__dot_0__acc_out 
                = vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_0__DOT__result_latch;
            vlSelfRef.ternary_pipeline__DOT__scale__DOT__prod_0 
                = (0x0000ffffffffffffULL & VL_MULS_QQQ(48, 
                                                       (0x0000ffffffffffffULL 
                                                        & VL_EXTENDS_QI(48,32, vlSelfRef.ternary_pipeline__DOT__gemm_result[0U])), 
                                                       (0x0000ffffffffffffULL 
                                                        & VL_EXTENDS_QI(48,17, 
                                                                        (0x0000ffffU 
                                                                         & (IData)(vlSelfRef.alpha))))));
            vlSelfRef.ternary_pipeline__DOT__scale__DOT__prod_1 
                = (0x0000ffffffffffffULL & VL_MULS_QQQ(48, 
                                                       (0x0000ffffffffffffULL 
                                                        & VL_EXTENDS_QI(48,32, vlSelfRef.ternary_pipeline__DOT__gemm_result[1U])), 
                                                       (0x0000ffffffffffffULL 
                                                        & VL_EXTENDS_QI(48,17, 
                                                                        (0x0000ffffU 
                                                                         & (IData)(
                                                                                (vlSelfRef.alpha 
                                                                                >> 0x10U)))))));
            vlSelfRef.ternary_pipeline__DOT__scale__DOT__prod_2 
                = (0x0000ffffffffffffULL & VL_MULS_QQQ(48, 
                                                       (0x0000ffffffffffffULL 
                                                        & VL_EXTENDS_QI(48,32, vlSelfRef.ternary_pipeline__DOT__gemm_result[2U])), 
                                                       (0x0000ffffffffffffULL 
                                                        & VL_EXTENDS_QI(48,17, 
                                                                        (0x0000ffffU 
                                                                         & (IData)(
                                                                                (vlSelfRef.alpha 
                                                                                >> 0x20U)))))));
            vlSelfRef.ternary_pipeline__DOT__scale__DOT__prod_3 
                = (0x0000ffffffffffffULL & VL_MULS_QQQ(48, 
                                                       (0x0000ffffffffffffULL 
                                                        & VL_EXTENDS_QI(48,32, vlSelfRef.ternary_pipeline__DOT__gemm_result[3U])), 
                                                       (0x0000ffffffffffffULL 
                                                        & VL_EXTENDS_QI(48,17, 
                                                                        (0x0000ffffU 
                                                                         & (IData)(
                                                                                (vlSelfRef.alpha 
                                                                                >> 0x30U)))))));
        } else {
            vlSelfRef.ternary_pipeline__DOT__gemm__DOT____Vcellout__dot_0__acc_out = 0U;
        }
        vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_1__DOT__weighted 
            = ((0U == (3U & ((IData)(vlSelfRef.ternary_pipeline__DOT__weight_enc_d1) 
                             >> 2U))) ? 0U : (0x000000ffU 
                                              & ((1U 
                                                  == 
                                                  (3U 
                                                   & ((IData)(vlSelfRef.ternary_pipeline__DOT__weight_enc_d1) 
                                                      >> 2U)))
                                                  ? (IData)(vlSelfRef.ternary_pipeline__DOT__q)
                                                  : 
                                                 (- (IData)(vlSelfRef.ternary_pipeline__DOT__q)))));
        vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_1__DOT__weighted_ext 
            = (((- (IData)((1U & ((IData)(vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_1__DOT__weighted) 
                                  >> 7U)))) << 8U) 
               | (IData)(vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_1__DOT__weighted));
        vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_1__DOT__next_acc 
            = (vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_1__DOT__acc 
               + vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_1__DOT__weighted_ext);
        if (((IData)(vlSelfRef.ternary_pipeline__DOT__q_valid) 
             & ((~ (IData)(vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_1__DOT__vector_done)) 
                | (IData)(vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_1__DOT__vector_done_delayed)))) {
            if ((1U == vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_1__DOT__count)) {
                vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_1__DOT__result_latch 
                    = vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_1__DOT__next_acc;
                __Vdly__ternary_pipeline__DOT__gemm__DOT__dot_1__DOT__vector_done = 1U;
                vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_1__DOT__acc = 0U;
                __Vdly__ternary_pipeline__DOT__gemm__DOT__dot_1__DOT__count = 4U;
            } else {
                __Vdly__ternary_pipeline__DOT__gemm__DOT__dot_1__DOT__count 
                    = (vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_1__DOT__count 
                       - (IData)(1U));
                __Vdly__ternary_pipeline__DOT__gemm__DOT__dot_1__DOT__vector_done = 0U;
                vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_1__DOT__acc 
                    = vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_1__DOT__next_acc;
            }
        } else {
            __Vdly__ternary_pipeline__DOT__gemm__DOT__dot_1__DOT__vector_done 
                = vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_1__DOT__vector_done;
        }
        vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_2__DOT__weighted 
            = ((0U == (3U & ((IData)(vlSelfRef.ternary_pipeline__DOT__weight_enc_d1) 
                             >> 4U))) ? 0U : (0x000000ffU 
                                              & ((1U 
                                                  == 
                                                  (3U 
                                                   & ((IData)(vlSelfRef.ternary_pipeline__DOT__weight_enc_d1) 
                                                      >> 4U)))
                                                  ? (IData)(vlSelfRef.ternary_pipeline__DOT__q)
                                                  : 
                                                 (- (IData)(vlSelfRef.ternary_pipeline__DOT__q)))));
        vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_2__DOT__weighted_ext 
            = (((- (IData)((1U & ((IData)(vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_2__DOT__weighted) 
                                  >> 7U)))) << 8U) 
               | (IData)(vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_2__DOT__weighted));
        vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_2__DOT__next_acc 
            = (vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_2__DOT__acc 
               + vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_2__DOT__weighted_ext);
        if (((IData)(vlSelfRef.ternary_pipeline__DOT__q_valid) 
             & ((~ (IData)(vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_2__DOT__vector_done)) 
                | (IData)(vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_2__DOT__vector_done_delayed)))) {
            if ((1U == vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_2__DOT__count)) {
                vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_2__DOT__result_latch 
                    = vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_2__DOT__next_acc;
                __Vdly__ternary_pipeline__DOT__gemm__DOT__dot_2__DOT__vector_done = 1U;
                vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_2__DOT__acc = 0U;
                __Vdly__ternary_pipeline__DOT__gemm__DOT__dot_2__DOT__count = 4U;
            } else {
                __Vdly__ternary_pipeline__DOT__gemm__DOT__dot_2__DOT__count 
                    = (vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_2__DOT__count 
                       - (IData)(1U));
                __Vdly__ternary_pipeline__DOT__gemm__DOT__dot_2__DOT__vector_done = 0U;
                vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_2__DOT__acc 
                    = vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_2__DOT__next_acc;
            }
        } else {
            __Vdly__ternary_pipeline__DOT__gemm__DOT__dot_2__DOT__vector_done 
                = vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_2__DOT__vector_done;
        }
        vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_3__DOT__weighted 
            = ((0U == (3U & ((IData)(vlSelfRef.ternary_pipeline__DOT__weight_enc_d1) 
                             >> 6U))) ? 0U : (0x000000ffU 
                                              & ((1U 
                                                  == 
                                                  (3U 
                                                   & ((IData)(vlSelfRef.ternary_pipeline__DOT__weight_enc_d1) 
                                                      >> 6U)))
                                                  ? (IData)(vlSelfRef.ternary_pipeline__DOT__q)
                                                  : 
                                                 (- (IData)(vlSelfRef.ternary_pipeline__DOT__q)))));
        vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_3__DOT__weighted_ext 
            = (((- (IData)((1U & ((IData)(vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_3__DOT__weighted) 
                                  >> 7U)))) << 8U) 
               | (IData)(vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_3__DOT__weighted));
        vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_3__DOT__next_acc 
            = (vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_3__DOT__acc 
               + vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_3__DOT__weighted_ext);
        if (((IData)(vlSelfRef.ternary_pipeline__DOT__q_valid) 
             & ((~ (IData)(vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_3__DOT__vector_done)) 
                | (IData)(vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_3__DOT__vector_done_delayed)))) {
            if ((1U == vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_3__DOT__count)) {
                vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_3__DOT__result_latch 
                    = vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_3__DOT__next_acc;
                __Vdly__ternary_pipeline__DOT__gemm__DOT__dot_3__DOT__vector_done = 1U;
                vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_3__DOT__acc = 0U;
                __Vdly__ternary_pipeline__DOT__gemm__DOT__dot_3__DOT__count = 4U;
            } else {
                __Vdly__ternary_pipeline__DOT__gemm__DOT__dot_3__DOT__count 
                    = (vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_3__DOT__count 
                       - (IData)(1U));
                __Vdly__ternary_pipeline__DOT__gemm__DOT__dot_3__DOT__vector_done = 0U;
                vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_3__DOT__acc 
                    = vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_3__DOT__next_acc;
            }
        } else {
            __Vdly__ternary_pipeline__DOT__gemm__DOT__dot_3__DOT__vector_done 
                = vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_3__DOT__vector_done;
        }
        vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_0__DOT__weighted 
            = ((0U == (3U & (IData)(vlSelfRef.ternary_pipeline__DOT__weight_enc_d1)))
                ? 0U : (0x000000ffU & ((1U == (3U & (IData)(vlSelfRef.ternary_pipeline__DOT__weight_enc_d1)))
                                        ? (IData)(vlSelfRef.ternary_pipeline__DOT__q)
                                        : (- (IData)(vlSelfRef.ternary_pipeline__DOT__q)))));
        vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_0__DOT__weighted_ext 
            = (((- (IData)((1U & ((IData)(vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_0__DOT__weighted) 
                                  >> 7U)))) << 8U) 
               | (IData)(vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_0__DOT__weighted));
        vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_0__DOT__next_acc 
            = (vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_0__DOT__acc 
               + vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_0__DOT__weighted_ext);
        if (((IData)(vlSelfRef.ternary_pipeline__DOT__q_valid) 
             & ((~ (IData)(vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_0__DOT__vector_done)) 
                | (IData)(vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_0__DOT__vector_done_delayed)))) {
            if ((1U == vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_0__DOT__count)) {
                vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_0__DOT__result_latch 
                    = vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_0__DOT__next_acc;
                __Vdly__ternary_pipeline__DOT__gemm__DOT__dot_0__DOT__vector_done = 1U;
                vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_0__DOT__acc = 0U;
                __Vdly__ternary_pipeline__DOT__gemm__DOT__dot_0__DOT__count = 4U;
            } else {
                __Vdly__ternary_pipeline__DOT__gemm__DOT__dot_0__DOT__count 
                    = (vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_0__DOT__count 
                       - (IData)(1U));
                __Vdly__ternary_pipeline__DOT__gemm__DOT__dot_0__DOT__vector_done = 0U;
                vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_0__DOT__acc 
                    = vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_0__DOT__next_acc;
            }
        } else {
            __Vdly__ternary_pipeline__DOT__gemm__DOT__dot_0__DOT__vector_done 
                = vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_0__DOT__vector_done;
        }
        if (vlSelfRef.ternary_pipeline__DOT__quant__DOT__product_valid) {
            vlSelfRef.ternary_pipeline__DOT__q = (VL_LTS_III(32, 0x0000007fU, 
                                                             VL_EXTENDS_II(32,30, 
                                                                           (0x3fffffffU 
                                                                            & VL_SHIFTRS_III(30,30,32, 
                                                                                (0x3fffffffU 
                                                                                & ((IData)(0x00004000U) 
                                                                                + vlSelfRef.ternary_pipeline__DOT__quant__DOT__product)), 0x0000000fU))))
                                                   ? 0x0000007fU
                                                   : 
                                                  (VL_GTS_III(32, 0xffffff81U, 
                                                              VL_EXTENDS_II(32,30, 
                                                                            (0x3fffffffU 
                                                                             & VL_SHIFTRS_III(30,30,32, 
                                                                                (0x3fffffffU 
                                                                                & ((IData)(0x00004000U) 
                                                                                + vlSelfRef.ternary_pipeline__DOT__quant__DOT__product)), 0x0000000fU))))
                                                    ? 0x00000081U
                                                    : 
                                                   (0x000000ffU 
                                                    & VL_SHIFTRS_III(30,30,32, 
                                                                     (0x3fffffffU 
                                                                      & ((IData)(0x00004000U) 
                                                                         + vlSelfRef.ternary_pipeline__DOT__quant__DOT__product)), 0x0000000fU))));
        }
        if (vlSelfRef.valid_in) {
            vlSelfRef.ternary_pipeline__DOT__weight_enc_d1 
                = vlSelfRef.weight_enc;
            vlSelfRef.ternary_pipeline__DOT__quant__DOT__product 
                = (0x3fffffffU & VL_MULS_III(30, (0x3fffffffU 
                                                  & VL_EXTENDS_II(30,8, (IData)(vlSelfRef.activation))), 
                                             (0x3fffffffU 
                                              & VL_EXTENDS_II(30,23, vlSelfRef.inv))));
        }
    } else {
        vlSelfRef.result[0U] = 0U;
        vlSelfRef.result[1U] = 0U;
        vlSelfRef.result[2U] = 0U;
        vlSelfRef.result[3U] = 0U;
        vlSelfRef.ternary_pipeline__DOT__gemm__DOT____Vcellout__dot_1__acc_out = 0U;
        vlSelfRef.ternary_pipeline__DOT__gemm__DOT____Vcellout__dot_2__acc_out = 0U;
        vlSelfRef.ternary_pipeline__DOT__gemm__DOT____Vcellout__dot_3__acc_out = 0U;
        vlSelfRef.ternary_pipeline__DOT__gemm__DOT____Vcellout__dot_0__acc_out = 0U;
        vlSelfRef.ternary_pipeline__DOT__scale__DOT__prod_0 = 0ULL;
        vlSelfRef.ternary_pipeline__DOT__scale__DOT__prod_1 = 0ULL;
        vlSelfRef.ternary_pipeline__DOT__scale__DOT__prod_2 = 0ULL;
        vlSelfRef.ternary_pipeline__DOT__scale__DOT__prod_3 = 0ULL;
        vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_1__DOT__acc = 0U;
        __Vdly__ternary_pipeline__DOT__gemm__DOT__dot_1__DOT__count = 4U;
        __Vdly__ternary_pipeline__DOT__gemm__DOT__dot_1__DOT__vector_done = 0U;
        vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_1__DOT__result_latch = 0U;
        vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_2__DOT__acc = 0U;
        __Vdly__ternary_pipeline__DOT__gemm__DOT__dot_2__DOT__count = 4U;
        __Vdly__ternary_pipeline__DOT__gemm__DOT__dot_2__DOT__vector_done = 0U;
        vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_2__DOT__result_latch = 0U;
        vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_3__DOT__acc = 0U;
        __Vdly__ternary_pipeline__DOT__gemm__DOT__dot_3__DOT__count = 4U;
        __Vdly__ternary_pipeline__DOT__gemm__DOT__dot_3__DOT__vector_done = 0U;
        vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_3__DOT__result_latch = 0U;
        vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_0__DOT__acc = 0U;
        __Vdly__ternary_pipeline__DOT__gemm__DOT__dot_0__DOT__count = 4U;
        __Vdly__ternary_pipeline__DOT__gemm__DOT__dot_0__DOT__vector_done = 0U;
        vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_0__DOT__result_latch = 0U;
        vlSelfRef.ternary_pipeline__DOT__weight_enc_d1 = 0U;
        vlSelfRef.ternary_pipeline__DOT__q = 0U;
        vlSelfRef.ternary_pipeline__DOT__quant__DOT__product = 0U;
    }
    vlSelfRef.ternary_pipeline__DOT__scale__DOT__valid_d1 
        = ((IData)(vlSelfRef.rst_n) && (IData)(vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_0__DOT__vector_done));
    vlSelfRef.ternary_pipeline__DOT__gemm_result[0U] 
        = vlSelfRef.ternary_pipeline__DOT__gemm__DOT____Vcellout__dot_0__acc_out;
    vlSelfRef.ternary_pipeline__DOT__gemm_result[1U] 
        = vlSelfRef.ternary_pipeline__DOT__gemm__DOT____Vcellout__dot_1__acc_out;
    vlSelfRef.ternary_pipeline__DOT__gemm_result[2U] 
        = (IData)((((QData)((IData)(vlSelfRef.ternary_pipeline__DOT__gemm__DOT____Vcellout__dot_3__acc_out)) 
                    << 0x00000020U) | (QData)((IData)(vlSelfRef.ternary_pipeline__DOT__gemm__DOT____Vcellout__dot_2__acc_out))));
    vlSelfRef.ternary_pipeline__DOT__gemm_result[3U] 
        = (IData)(((((QData)((IData)(vlSelfRef.ternary_pipeline__DOT__gemm__DOT____Vcellout__dot_3__acc_out)) 
                     << 0x00000020U) | (QData)((IData)(vlSelfRef.ternary_pipeline__DOT__gemm__DOT____Vcellout__dot_2__acc_out))) 
                   >> 0x00000020U));
    vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_1__DOT__count 
        = __Vdly__ternary_pipeline__DOT__gemm__DOT__dot_1__DOT__count;
    vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_2__DOT__count 
        = __Vdly__ternary_pipeline__DOT__gemm__DOT__dot_2__DOT__count;
    vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_3__DOT__count 
        = __Vdly__ternary_pipeline__DOT__gemm__DOT__dot_3__DOT__count;
    vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_0__DOT__count 
        = __Vdly__ternary_pipeline__DOT__gemm__DOT__dot_0__DOT__count;
    vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_1__DOT__vector_done_delayed 
        = ((IData)(vlSelfRef.rst_n) && (IData)(vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_1__DOT__vector_done));
    vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_2__DOT__vector_done_delayed 
        = ((IData)(vlSelfRef.rst_n) && (IData)(vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_2__DOT__vector_done));
    vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_3__DOT__vector_done_delayed 
        = ((IData)(vlSelfRef.rst_n) && (IData)(vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_3__DOT__vector_done));
    vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_0__DOT__vector_done_delayed 
        = ((IData)(vlSelfRef.rst_n) && (IData)(vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_0__DOT__vector_done));
    vlSelfRef.ternary_pipeline__DOT__q_valid = ((IData)(vlSelfRef.rst_n) 
                                                && (IData)(vlSelfRef.ternary_pipeline__DOT__quant__DOT__product_valid));
    vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_1__DOT__vector_done 
        = __Vdly__ternary_pipeline__DOT__gemm__DOT__dot_1__DOT__vector_done;
    vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_2__DOT__vector_done 
        = __Vdly__ternary_pipeline__DOT__gemm__DOT__dot_2__DOT__vector_done;
    vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_3__DOT__vector_done 
        = __Vdly__ternary_pipeline__DOT__gemm__DOT__dot_3__DOT__vector_done;
    vlSelfRef.ternary_pipeline__DOT__gemm__DOT__dot_0__DOT__vector_done 
        = __Vdly__ternary_pipeline__DOT__gemm__DOT__dot_0__DOT__vector_done;
    vlSelfRef.ternary_pipeline__DOT__quant__DOT__product_valid 
        = ((IData)(vlSelfRef.rst_n) && (IData)(vlSelfRef.valid_in));
}

void Vternary_pipeline___024root___eval_nba(Vternary_pipeline___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vternary_pipeline___024root___eval_nba\n"); );
    Vternary_pipeline__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((3ULL & vlSelfRef.__VnbaTriggered[0U])) {
        Vternary_pipeline___024root___nba_sequent__TOP__0(vlSelf);
    }
}

void Vternary_pipeline___024root___trigger_orInto__act_vec_vec(VlUnpacked<QData/*63:0*/, 1> &out, const VlUnpacked<QData/*63:0*/, 1> &in) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vternary_pipeline___024root___trigger_orInto__act_vec_vec\n"); );
    // Locals
    IData/*31:0*/ n;
    // Body
    n = 0U;
    do {
        out[n] = (out[n] | in[n]);
        n = ((IData)(1U) + n);
    } while ((0U >= n));
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vternary_pipeline___024root___dump_triggers__act(const VlUnpacked<QData/*63:0*/, 1> &triggers, const std::string &tag);
#endif  // VL_DEBUG

bool Vternary_pipeline___024root___eval_phase__act(Vternary_pipeline___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vternary_pipeline___024root___eval_phase__act\n"); );
    Vternary_pipeline__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    Vternary_pipeline___024root___eval_triggers_vec__act(vlSelf);
#ifdef VL_DEBUG
    if (VL_UNLIKELY(vlSymsp->_vm_contextp__->debug())) {
        Vternary_pipeline___024root___dump_triggers__act(vlSelfRef.__VactTriggered, "act"s);
    }
#endif
    Vternary_pipeline___024root___trigger_orInto__act_vec_vec(vlSelfRef.__VnbaTriggered, vlSelfRef.__VactTriggered);
    return (0U);
}

void Vternary_pipeline___024root___trigger_clear__act(VlUnpacked<QData/*63:0*/, 1> &out) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vternary_pipeline___024root___trigger_clear__act\n"); );
    // Locals
    IData/*31:0*/ n;
    // Body
    n = 0U;
    do {
        out[n] = 0ULL;
        n = ((IData)(1U) + n);
    } while ((1U > n));
}

bool Vternary_pipeline___024root___eval_phase__nba(Vternary_pipeline___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vternary_pipeline___024root___eval_phase__nba\n"); );
    Vternary_pipeline__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    CData/*0:0*/ __VnbaExecute;
    // Body
    __VnbaExecute = Vternary_pipeline___024root___trigger_anySet__act(vlSelfRef.__VnbaTriggered);
    if (__VnbaExecute) {
        Vternary_pipeline___024root___eval_nba(vlSelf);
        Vternary_pipeline___024root___trigger_clear__act(vlSelfRef.__VnbaTriggered);
    }
    return (__VnbaExecute);
}

void Vternary_pipeline___024root___eval(Vternary_pipeline___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vternary_pipeline___024root___eval\n"); );
    Vternary_pipeline__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    IData/*31:0*/ __VnbaIterCount;
    // Body
    __VnbaIterCount = 0U;
    do {
        if (VL_UNLIKELY(((0x00002710U < __VnbaIterCount)))) {
#ifdef VL_DEBUG
            Vternary_pipeline___024root___dump_triggers__act(vlSelfRef.__VnbaTriggered, "nba"s);
#endif
            VL_FATAL_MT("../rtl/ternary_pipeline.v", 13, "", "DIDNOTCONVERGE: NBA region did not converge after '--converge-limit' of 10000 tries");
        }
        __VnbaIterCount = ((IData)(1U) + __VnbaIterCount);
        vlSelfRef.__VactIterCount = 0U;
        do {
            if (VL_UNLIKELY(((0x00002710U < vlSelfRef.__VactIterCount)))) {
#ifdef VL_DEBUG
                Vternary_pipeline___024root___dump_triggers__act(vlSelfRef.__VactTriggered, "act"s);
#endif
                VL_FATAL_MT("../rtl/ternary_pipeline.v", 13, "", "DIDNOTCONVERGE: Active region did not converge after '--converge-limit' of 10000 tries");
            }
            vlSelfRef.__VactIterCount = ((IData)(1U) 
                                         + vlSelfRef.__VactIterCount);
            vlSelfRef.__VactPhaseResult = Vternary_pipeline___024root___eval_phase__act(vlSelf);
        } while (vlSelfRef.__VactPhaseResult);
        vlSelfRef.__VnbaPhaseResult = Vternary_pipeline___024root___eval_phase__nba(vlSelf);
    } while (vlSelfRef.__VnbaPhaseResult);
}

#ifdef VL_DEBUG
void Vternary_pipeline___024root___eval_debug_assertions(Vternary_pipeline___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vternary_pipeline___024root___eval_debug_assertions\n"); );
    Vternary_pipeline__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if (VL_UNLIKELY(((vlSelfRef.clk & 0xfeU)))) {
        Verilated::overWidthError("clk");
    }
    if (VL_UNLIKELY(((vlSelfRef.rst_n & 0xfeU)))) {
        Verilated::overWidthError("rst_n");
    }
    if (VL_UNLIKELY(((vlSelfRef.valid_in & 0xfeU)))) {
        Verilated::overWidthError("valid_in");
    }
    if (VL_UNLIKELY(((vlSelfRef.inv & 0xffc00000U)))) {
        Verilated::overWidthError("inv");
    }
}
#endif  // VL_DEBUG
