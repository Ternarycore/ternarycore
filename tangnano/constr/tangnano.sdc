// Tang Nano 9k timing constraints
// 27 MHz onboard oscillator → period = 37.037 ns

create_clock -name clk_27M -period 37.037 -waveform {0 18.518} [get_ports clk_27M]
