// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vternary_pipeline.h for the primary calling header

#include "Vternary_pipeline__pch.h"

VL_ATTR_COLD void Vternary_pipeline___024root___eval_static(Vternary_pipeline___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vternary_pipeline___024root___eval_static\n"); );
    Vternary_pipeline__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    const uint64_t __VscopeHash = VL_MURMUR64_HASH(vlSelf->vlNamep);
    vlSelf->ternary_pipeline__DOT__scale__DOT__scale_ch__Vstatic__trunc = VL_SCOPED_RAND_RESET_I(16, __VscopeHash, 8465636708997167989ull);
    vlSelf->ternary_pipeline__DOT__scale__DOT__scale_ch__Vstatic__round = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 5184951196010768540ull);
    vlSelf->ternary_pipeline__DOT__scale__DOT__scale_ch__Vstatic__shifted = VL_SCOPED_RAND_RESET_Q(48, __VscopeHash, 11176252077993714569ull);
    vlSelfRef.__Vtrigprevexpr___TOP__clk__0 = vlSelfRef.clk;
    vlSelfRef.__Vtrigprevexpr___TOP__rst_n__0 = vlSelfRef.rst_n;
}

VL_ATTR_COLD void Vternary_pipeline___024root___eval_static__TOP(Vternary_pipeline___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vternary_pipeline___024root___eval_static__TOP\n"); );
    Vternary_pipeline__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    const uint64_t __VscopeHash = VL_MURMUR64_HASH(vlSelf->vlNamep);
    vlSelf->ternary_pipeline__DOT__scale__DOT__scale_ch__Vstatic__trunc = VL_SCOPED_RAND_RESET_I(16, __VscopeHash, 8465636708997167989ull);
    vlSelf->ternary_pipeline__DOT__scale__DOT__scale_ch__Vstatic__round = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 5184951196010768540ull);
    vlSelf->ternary_pipeline__DOT__scale__DOT__scale_ch__Vstatic__shifted = VL_SCOPED_RAND_RESET_Q(48, __VscopeHash, 11176252077993714569ull);
}

VL_ATTR_COLD void Vternary_pipeline___024root___eval_initial(Vternary_pipeline___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vternary_pipeline___024root___eval_initial\n"); );
    Vternary_pipeline__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

VL_ATTR_COLD void Vternary_pipeline___024root___eval_final(Vternary_pipeline___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vternary_pipeline___024root___eval_final\n"); );
    Vternary_pipeline__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vternary_pipeline___024root___dump_triggers__stl(const VlUnpacked<QData/*63:0*/, 1> &triggers, const std::string &tag);
#endif  // VL_DEBUG
VL_ATTR_COLD bool Vternary_pipeline___024root___eval_phase__stl(Vternary_pipeline___024root* vlSelf);

VL_ATTR_COLD void Vternary_pipeline___024root___eval_settle(Vternary_pipeline___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vternary_pipeline___024root___eval_settle\n"); );
    Vternary_pipeline__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    IData/*31:0*/ __VstlIterCount;
    // Body
    __VstlIterCount = 0U;
    vlSelfRef.__VstlFirstIteration = 1U;
    do {
        if (VL_UNLIKELY(((0x00002710U < __VstlIterCount)))) {
#ifdef VL_DEBUG
            Vternary_pipeline___024root___dump_triggers__stl(vlSelfRef.__VstlTriggered, "stl"s);
#endif
            VL_FATAL_MT("../rtl/ternary_pipeline.v", 13, "", "DIDNOTCONVERGE: Settle region did not converge after '--converge-limit' of 10000 tries");
        }
        __VstlIterCount = ((IData)(1U) + __VstlIterCount);
        vlSelfRef.__VstlPhaseResult = Vternary_pipeline___024root___eval_phase__stl(vlSelf);
        vlSelfRef.__VstlFirstIteration = 0U;
    } while (vlSelfRef.__VstlPhaseResult);
}

VL_ATTR_COLD void Vternary_pipeline___024root___eval_triggers_vec__stl(Vternary_pipeline___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vternary_pipeline___024root___eval_triggers_vec__stl\n"); );
    Vternary_pipeline__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.__VstlTriggered[0U] = ((0xfffffffffffffffeULL 
                                      & vlSelfRef.__VstlTriggered[0U]) 
                                     | (IData)((IData)(vlSelfRef.__VstlFirstIteration)));
}

VL_ATTR_COLD bool Vternary_pipeline___024root___trigger_anySet__stl(const VlUnpacked<QData/*63:0*/, 1> &in);

#ifdef VL_DEBUG
VL_ATTR_COLD void Vternary_pipeline___024root___dump_triggers__stl(const VlUnpacked<QData/*63:0*/, 1> &triggers, const std::string &tag) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vternary_pipeline___024root___dump_triggers__stl\n"); );
    // Body
    if ((1U & (~ (IData)(Vternary_pipeline___024root___trigger_anySet__stl(triggers))))) {
        VL_DBG_MSGS("         No '" + tag + "' region triggers active\n");
    }
    if ((1U & (IData)(triggers[0U]))) {
        VL_DBG_MSGS("         '" + tag + "' region trigger index 0 is active: Internal 'stl' trigger - first iteration\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD bool Vternary_pipeline___024root___trigger_anySet__stl(const VlUnpacked<QData/*63:0*/, 1> &in) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vternary_pipeline___024root___trigger_anySet__stl\n"); );
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

VL_ATTR_COLD void Vternary_pipeline___024root___stl_sequent__TOP__0(Vternary_pipeline___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vternary_pipeline___024root___stl_sequent__TOP__0\n"); );
    Vternary_pipeline__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
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
}

VL_ATTR_COLD void Vternary_pipeline___024root___eval_stl(Vternary_pipeline___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vternary_pipeline___024root___eval_stl\n"); );
    Vternary_pipeline__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1ULL & vlSelfRef.__VstlTriggered[0U])) {
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
    }
}

VL_ATTR_COLD bool Vternary_pipeline___024root___eval_phase__stl(Vternary_pipeline___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vternary_pipeline___024root___eval_phase__stl\n"); );
    Vternary_pipeline__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    CData/*0:0*/ __VstlExecute;
    // Body
    Vternary_pipeline___024root___eval_triggers_vec__stl(vlSelf);
#ifdef VL_DEBUG
    if (VL_UNLIKELY(vlSymsp->_vm_contextp__->debug())) {
        Vternary_pipeline___024root___dump_triggers__stl(vlSelfRef.__VstlTriggered, "stl"s);
    }
#endif
    __VstlExecute = Vternary_pipeline___024root___trigger_anySet__stl(vlSelfRef.__VstlTriggered);
    if (__VstlExecute) {
        Vternary_pipeline___024root___eval_stl(vlSelf);
    }
    return (__VstlExecute);
}

bool Vternary_pipeline___024root___trigger_anySet__act(const VlUnpacked<QData/*63:0*/, 1> &in);

#ifdef VL_DEBUG
VL_ATTR_COLD void Vternary_pipeline___024root___dump_triggers__act(const VlUnpacked<QData/*63:0*/, 1> &triggers, const std::string &tag) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vternary_pipeline___024root___dump_triggers__act\n"); );
    // Body
    if ((1U & (~ (IData)(Vternary_pipeline___024root___trigger_anySet__act(triggers))))) {
        VL_DBG_MSGS("         No '" + tag + "' region triggers active\n");
    }
    if ((1U & (IData)(triggers[0U]))) {
        VL_DBG_MSGS("         '" + tag + "' region trigger index 0 is active: @(posedge clk)\n");
    }
    if ((1U & (IData)((triggers[0U] >> 1U)))) {
        VL_DBG_MSGS("         '" + tag + "' region trigger index 1 is active: @(negedge rst_n)\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD void Vternary_pipeline___024root___ctor_var_reset(Vternary_pipeline___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vternary_pipeline___024root___ctor_var_reset\n"); );
    Vternary_pipeline__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    const uint64_t __VscopeHash = VL_MURMUR64_HASH(vlSelf->vlNamep);
    vlSelf->clk = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 16707436170211756652ull);
    vlSelf->rst_n = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 1638864771569018232ull);
    vlSelf->valid_in = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 16540271516330450727ull);
    vlSelf->activation = VL_SCOPED_RAND_RESET_I(8, __VscopeHash, 2320115052395106594ull);
    vlSelf->inv = VL_SCOPED_RAND_RESET_I(22, __VscopeHash, 1048193178933859186ull);
    vlSelf->alpha = VL_SCOPED_RAND_RESET_Q(64, __VscopeHash, 4569310102327567611ull);
    vlSelf->weight_enc = VL_SCOPED_RAND_RESET_I(8, __VscopeHash, 5887195072097697783ull);
    VL_SCOPED_RAND_RESET_W(128, vlSelf->result, __VscopeHash, 16664408842984530663ull);
    vlSelf->valid_out = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 8744939437868816662ull);
    vlSelf->ternary_pipeline__DOT__q = VL_SCOPED_RAND_RESET_I(8, __VscopeHash, 7843855796620137626ull);
    vlSelf->ternary_pipeline__DOT__q_valid = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 12231201446244772843ull);
    VL_SCOPED_RAND_RESET_W(128, vlSelf->ternary_pipeline__DOT__gemm_result, __VscopeHash, 392862365167480064ull);
    vlSelf->ternary_pipeline__DOT__weight_enc_d1 = VL_SCOPED_RAND_RESET_I(8, __VscopeHash, 7265418569586535004ull);
    vlSelf->ternary_pipeline__DOT__quant__DOT__product = VL_SCOPED_RAND_RESET_I(30, __VscopeHash, 2162613048458756884ull);
    vlSelf->ternary_pipeline__DOT__quant__DOT__product_valid = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 10584455747769603725ull);
    vlSelf->ternary_pipeline__DOT__gemm__DOT____Vcellout__dot_0__acc_out = 0;
    vlSelf->ternary_pipeline__DOT__gemm__DOT____Vcellout__dot_1__acc_out = 0;
    vlSelf->ternary_pipeline__DOT__gemm__DOT____Vcellout__dot_2__acc_out = 0;
    vlSelf->ternary_pipeline__DOT__gemm__DOT____Vcellout__dot_3__acc_out = 0;
    vlSelf->ternary_pipeline__DOT__gemm__DOT__dot_0__DOT__weighted = VL_SCOPED_RAND_RESET_I(8, __VscopeHash, 6056167951488878893ull);
    vlSelf->ternary_pipeline__DOT__gemm__DOT__dot_0__DOT__weighted_ext = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 14398489223667678ull);
    vlSelf->ternary_pipeline__DOT__gemm__DOT__dot_0__DOT__acc = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 7759203627579728141ull);
    vlSelf->ternary_pipeline__DOT__gemm__DOT__dot_0__DOT__count = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 16701926029966563931ull);
    vlSelf->ternary_pipeline__DOT__gemm__DOT__dot_0__DOT__vector_done = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 13221986496372015505ull);
    vlSelf->ternary_pipeline__DOT__gemm__DOT__dot_0__DOT__result_latch = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 16098913957127978403ull);
    vlSelf->ternary_pipeline__DOT__gemm__DOT__dot_0__DOT__vector_done_delayed = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 17693916166134705523ull);
    vlSelf->ternary_pipeline__DOT__gemm__DOT__dot_0__DOT__next_acc = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 5850519245009433685ull);
    vlSelf->ternary_pipeline__DOT__gemm__DOT__dot_1__DOT__weighted = VL_SCOPED_RAND_RESET_I(8, __VscopeHash, 6544196504142347673ull);
    vlSelf->ternary_pipeline__DOT__gemm__DOT__dot_1__DOT__weighted_ext = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 5718856378700897750ull);
    vlSelf->ternary_pipeline__DOT__gemm__DOT__dot_1__DOT__acc = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 16263263084449150118ull);
    vlSelf->ternary_pipeline__DOT__gemm__DOT__dot_1__DOT__count = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 4700832288139982651ull);
    vlSelf->ternary_pipeline__DOT__gemm__DOT__dot_1__DOT__vector_done = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 8047607651833431012ull);
    vlSelf->ternary_pipeline__DOT__gemm__DOT__dot_1__DOT__result_latch = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 17976608196214146847ull);
    vlSelf->ternary_pipeline__DOT__gemm__DOT__dot_1__DOT__vector_done_delayed = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 4720074172225313199ull);
    vlSelf->ternary_pipeline__DOT__gemm__DOT__dot_1__DOT__next_acc = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 12237590562812608373ull);
    vlSelf->ternary_pipeline__DOT__gemm__DOT__dot_2__DOT__weighted = VL_SCOPED_RAND_RESET_I(8, __VscopeHash, 1708658707372006915ull);
    vlSelf->ternary_pipeline__DOT__gemm__DOT__dot_2__DOT__weighted_ext = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 392688855802840383ull);
    vlSelf->ternary_pipeline__DOT__gemm__DOT__dot_2__DOT__acc = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 1057001466765625990ull);
    vlSelf->ternary_pipeline__DOT__gemm__DOT__dot_2__DOT__count = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 4952211495110189697ull);
    vlSelf->ternary_pipeline__DOT__gemm__DOT__dot_2__DOT__vector_done = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 10540194048753328723ull);
    vlSelf->ternary_pipeline__DOT__gemm__DOT__dot_2__DOT__result_latch = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 14866559416213731398ull);
    vlSelf->ternary_pipeline__DOT__gemm__DOT__dot_2__DOT__vector_done_delayed = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 3151425992968701981ull);
    vlSelf->ternary_pipeline__DOT__gemm__DOT__dot_2__DOT__next_acc = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 9337899981626717049ull);
    vlSelf->ternary_pipeline__DOT__gemm__DOT__dot_3__DOT__weighted = VL_SCOPED_RAND_RESET_I(8, __VscopeHash, 11900544800202478583ull);
    vlSelf->ternary_pipeline__DOT__gemm__DOT__dot_3__DOT__weighted_ext = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 17178585304808059153ull);
    vlSelf->ternary_pipeline__DOT__gemm__DOT__dot_3__DOT__acc = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 1618959247276311362ull);
    vlSelf->ternary_pipeline__DOT__gemm__DOT__dot_3__DOT__count = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 6970660472769477832ull);
    vlSelf->ternary_pipeline__DOT__gemm__DOT__dot_3__DOT__vector_done = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 1613801342672189183ull);
    vlSelf->ternary_pipeline__DOT__gemm__DOT__dot_3__DOT__result_latch = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 6341736283158273087ull);
    vlSelf->ternary_pipeline__DOT__gemm__DOT__dot_3__DOT__vector_done_delayed = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 10649211786046515356ull);
    vlSelf->ternary_pipeline__DOT__gemm__DOT__dot_3__DOT__next_acc = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 14939436820004092099ull);
    vlSelf->ternary_pipeline__DOT__scale__DOT__prod_0 = VL_SCOPED_RAND_RESET_Q(48, __VscopeHash, 7745494535795749287ull);
    vlSelf->ternary_pipeline__DOT__scale__DOT__prod_1 = VL_SCOPED_RAND_RESET_Q(48, __VscopeHash, 12456646982875662797ull);
    vlSelf->ternary_pipeline__DOT__scale__DOT__prod_2 = VL_SCOPED_RAND_RESET_Q(48, __VscopeHash, 13810331141676031732ull);
    vlSelf->ternary_pipeline__DOT__scale__DOT__prod_3 = VL_SCOPED_RAND_RESET_Q(48, __VscopeHash, 5247387671214126844ull);
    vlSelf->ternary_pipeline__DOT__scale__DOT__valid_d1 = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 5831845817855358105ull);
    for (int __Vi0 = 0; __Vi0 < 1; ++__Vi0) {
        vlSelf->__VstlTriggered[__Vi0] = 0;
    }
    for (int __Vi0 = 0; __Vi0 < 1; ++__Vi0) {
        vlSelf->__VactTriggered[__Vi0] = 0;
    }
    vlSelf->__Vtrigprevexpr___TOP__clk__0 = 0;
    vlSelf->__Vtrigprevexpr___TOP__rst_n__0 = 0;
    for (int __Vi0 = 0; __Vi0 < 1; ++__Vi0) {
        vlSelf->__VnbaTriggered[__Vi0] = 0;
    }
}
