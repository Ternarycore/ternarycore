// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vternary_pipeline.h for the primary calling header

#include "Vternary_pipeline__pch.h"

void Vternary_pipeline___024root___ctor_var_reset(Vternary_pipeline___024root* vlSelf);

Vternary_pipeline___024root::Vternary_pipeline___024root(Vternary_pipeline__Syms* symsp, const char* namep)
 {
    vlSymsp = symsp;
    vlNamep = strdup(namep);
    // Reset structure values
    Vternary_pipeline___024root___ctor_var_reset(this);
}

void Vternary_pipeline___024root::__Vconfigure(bool first) {
    (void)first;  // Prevent unused variable warning
}

Vternary_pipeline___024root::~Vternary_pipeline___024root() {
    VL_DO_DANGLING(std::free(const_cast<char*>(vlNamep)), vlNamep);
}
