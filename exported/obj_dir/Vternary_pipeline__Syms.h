// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Symbol table internal header
//
// Internal details; most calling programs do not need this header,
// unless using verilator public meta comments.

#ifndef VERILATED_VTERNARY_PIPELINE__SYMS_H_
#define VERILATED_VTERNARY_PIPELINE__SYMS_H_  // guard

#include "verilated.h"

// INCLUDE MODEL CLASS

#include "Vternary_pipeline.h"

// INCLUDE MODULE CLASSES
#include "Vternary_pipeline___024root.h"

// SYMS CLASS (contains all model state)
class alignas(VL_CACHE_LINE_BYTES) Vternary_pipeline__Syms final : public VerilatedSyms {
  public:
    // INTERNAL STATE
    Vternary_pipeline* const __Vm_modelp;
    VlDeleter __Vm_deleter;
    bool __Vm_didInit = false;

    // MODULE INSTANCE STATE
    Vternary_pipeline___024root    TOP;

    // CONSTRUCTORS
    Vternary_pipeline__Syms(VerilatedContext* contextp, const char* namep, Vternary_pipeline* modelp);
    ~Vternary_pipeline__Syms();

    // METHODS
    const char* name() const { return TOP.vlNamep; }
};

#endif  // guard
