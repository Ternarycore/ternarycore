# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "ACC_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "COLS" -parent ${Page_0}
  ipgui::add_param $IPINST -name "DEPTH_MAX" -parent ${Page_0}
  ipgui::add_param $IPINST -name "WADDR_W" -parent ${Page_0}


}

proc update_PARAM_VALUE.ACC_WIDTH { PARAM_VALUE.ACC_WIDTH } {
	# Procedure called to update ACC_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ACC_WIDTH { PARAM_VALUE.ACC_WIDTH } {
	# Procedure called to validate ACC_WIDTH
	return true
}

proc update_PARAM_VALUE.COLS { PARAM_VALUE.COLS } {
	# Procedure called to update COLS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.COLS { PARAM_VALUE.COLS } {
	# Procedure called to validate COLS
	return true
}

proc update_PARAM_VALUE.DEPTH_MAX { PARAM_VALUE.DEPTH_MAX } {
	# Procedure called to update DEPTH_MAX when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DEPTH_MAX { PARAM_VALUE.DEPTH_MAX } {
	# Procedure called to validate DEPTH_MAX
	return true
}

proc update_PARAM_VALUE.WADDR_W { PARAM_VALUE.WADDR_W } {
	# Procedure called to update WADDR_W when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.WADDR_W { PARAM_VALUE.WADDR_W } {
	# Procedure called to validate WADDR_W
	return true
}


proc update_MODELPARAM_VALUE.DEPTH_MAX { MODELPARAM_VALUE.DEPTH_MAX PARAM_VALUE.DEPTH_MAX } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DEPTH_MAX}] ${MODELPARAM_VALUE.DEPTH_MAX}
}

proc update_MODELPARAM_VALUE.COLS { MODELPARAM_VALUE.COLS PARAM_VALUE.COLS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.COLS}] ${MODELPARAM_VALUE.COLS}
}

proc update_MODELPARAM_VALUE.ACC_WIDTH { MODELPARAM_VALUE.ACC_WIDTH PARAM_VALUE.ACC_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ACC_WIDTH}] ${MODELPARAM_VALUE.ACC_WIDTH}
}

proc update_MODELPARAM_VALUE.WADDR_W { MODELPARAM_VALUE.WADDR_W PARAM_VALUE.WADDR_W } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.WADDR_W}] ${MODELPARAM_VALUE.WADDR_W}
}

