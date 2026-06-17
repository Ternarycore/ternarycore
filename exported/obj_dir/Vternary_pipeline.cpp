// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Model implementation (design independent parts)

#include "Vternary_pipeline__pch.h"

//============================================================
// Constructors

Vternary_pipeline::Vternary_pipeline(VerilatedContext* _vcontextp__, const char* _vcname__)
    : VerilatedModel{*_vcontextp__}
    , vlSymsp{new Vternary_pipeline__Syms(contextp(), _vcname__, this)}
    , clk{vlSymsp->TOP.clk}
    , rst_n{vlSymsp->TOP.rst_n}
    , valid_in{vlSymsp->TOP.valid_in}
    , activation{vlSymsp->TOP.activation}
    , weight_enc{vlSymsp->TOP.weight_enc}
    , valid_out{vlSymsp->TOP.valid_out}
    , inv{vlSymsp->TOP.inv}
    , result{vlSymsp->TOP.result}
    , alpha{vlSymsp->TOP.alpha}
    , rootp{&(vlSymsp->TOP)}
{
    // Register model with the context
    contextp()->addModel(this);
}

Vternary_pipeline::Vternary_pipeline(const char* _vcname__)
    : Vternary_pipeline(Verilated::threadContextp(), _vcname__)
{
}

//============================================================
// Destructor

Vternary_pipeline::~Vternary_pipeline() {
    delete vlSymsp;
}

//============================================================
// Evaluation function

#ifdef VL_DEBUG
void Vternary_pipeline___024root___eval_debug_assertions(Vternary_pipeline___024root* vlSelf);
#endif  // VL_DEBUG
void Vternary_pipeline___024root___eval_static(Vternary_pipeline___024root* vlSelf);
void Vternary_pipeline___024root___eval_initial(Vternary_pipeline___024root* vlSelf);
void Vternary_pipeline___024root___eval_settle(Vternary_pipeline___024root* vlSelf);
void Vternary_pipeline___024root___eval(Vternary_pipeline___024root* vlSelf);

void Vternary_pipeline::eval_step() {
    VL_DEBUG_IF(VL_DBG_MSGF("+++++TOP Evaluate Vternary_pipeline::eval_step\n"); );
#ifdef VL_DEBUG
    // Debug assertions
    Vternary_pipeline___024root___eval_debug_assertions(&(vlSymsp->TOP));
#endif  // VL_DEBUG
    vlSymsp->__Vm_deleter.deleteAll();
    if (VL_UNLIKELY(!vlSymsp->__Vm_didInit)) {
        VL_DEBUG_IF(VL_DBG_MSGF("+ Initial\n"););
        Vternary_pipeline___024root___eval_static(&(vlSymsp->TOP));
        Vternary_pipeline___024root___eval_initial(&(vlSymsp->TOP));
        Vternary_pipeline___024root___eval_settle(&(vlSymsp->TOP));
        vlSymsp->__Vm_didInit = true;
    }
    VL_DEBUG_IF(VL_DBG_MSGF("+ Eval\n"););
    Vternary_pipeline___024root___eval(&(vlSymsp->TOP));
    // Evaluate cleanup
    Verilated::endOfEval(vlSymsp->__Vm_evalMsgQp);
}

//============================================================
// Events and timing
bool Vternary_pipeline::eventsPending() { return false; }

uint64_t Vternary_pipeline::nextTimeSlot() {
    VL_FATAL_MT(__FILE__, __LINE__, "", "No delays in the design");
    return 0;
}

//============================================================
// Utilities

const char* Vternary_pipeline::name() const {
    return vlSymsp->name();
}

//============================================================
// Invoke final blocks

void Vternary_pipeline___024root___eval_final(Vternary_pipeline___024root* vlSelf);

VL_ATTR_COLD void Vternary_pipeline::final() {
    contextp()->executingFinal(true);
    Vternary_pipeline___024root___eval_final(&(vlSymsp->TOP));
    contextp()->executingFinal(false);
}

//============================================================
// Implementations of abstract methods from VerilatedModel

const char* Vternary_pipeline::hierName() const { return vlSymsp->name(); }
const char* Vternary_pipeline::modelName() const { return "Vternary_pipeline"; }
unsigned Vternary_pipeline::threads() const { return 1; }
void Vternary_pipeline::prepareClone() const { contextp()->prepareClone(); }
void Vternary_pipeline::atClone() const {
    contextp()->threadPoolpOnClone();
}
