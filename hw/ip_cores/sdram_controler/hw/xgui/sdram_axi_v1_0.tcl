# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "SDRAM_ADDR_W" -parent ${Page_0}
  ipgui::add_param $IPINST -name "SDRAM_COL_W" -parent ${Page_0}
  ipgui::add_param $IPINST -name "SDRAM_MHZ" -parent ${Page_0}
  ipgui::add_param $IPINST -name "SDRAM_READ_LATENCY" -parent ${Page_0}


}

proc update_PARAM_VALUE.SDRAM_ADDR_W { PARAM_VALUE.SDRAM_ADDR_W } {
	# Procedure called to update SDRAM_ADDR_W when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.SDRAM_ADDR_W { PARAM_VALUE.SDRAM_ADDR_W } {
	# Procedure called to validate SDRAM_ADDR_W
	return true
}

proc update_PARAM_VALUE.SDRAM_COL_W { PARAM_VALUE.SDRAM_COL_W } {
	# Procedure called to update SDRAM_COL_W when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.SDRAM_COL_W { PARAM_VALUE.SDRAM_COL_W } {
	# Procedure called to validate SDRAM_COL_W
	return true
}

proc update_PARAM_VALUE.SDRAM_MHZ { PARAM_VALUE.SDRAM_MHZ } {
	# Procedure called to update SDRAM_MHZ when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.SDRAM_MHZ { PARAM_VALUE.SDRAM_MHZ } {
	# Procedure called to validate SDRAM_MHZ
	return true
}

proc update_PARAM_VALUE.SDRAM_READ_LATENCY { PARAM_VALUE.SDRAM_READ_LATENCY } {
	# Procedure called to update SDRAM_READ_LATENCY when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.SDRAM_READ_LATENCY { PARAM_VALUE.SDRAM_READ_LATENCY } {
	# Procedure called to validate SDRAM_READ_LATENCY
	return true
}


proc update_MODELPARAM_VALUE.SDRAM_MHZ { MODELPARAM_VALUE.SDRAM_MHZ PARAM_VALUE.SDRAM_MHZ } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.SDRAM_MHZ}] ${MODELPARAM_VALUE.SDRAM_MHZ}
}

proc update_MODELPARAM_VALUE.SDRAM_ADDR_W { MODELPARAM_VALUE.SDRAM_ADDR_W PARAM_VALUE.SDRAM_ADDR_W } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.SDRAM_ADDR_W}] ${MODELPARAM_VALUE.SDRAM_ADDR_W}
}

proc update_MODELPARAM_VALUE.SDRAM_COL_W { MODELPARAM_VALUE.SDRAM_COL_W PARAM_VALUE.SDRAM_COL_W } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.SDRAM_COL_W}] ${MODELPARAM_VALUE.SDRAM_COL_W}
}

proc update_MODELPARAM_VALUE.SDRAM_READ_LATENCY { MODELPARAM_VALUE.SDRAM_READ_LATENCY PARAM_VALUE.SDRAM_READ_LATENCY } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.SDRAM_READ_LATENCY}] ${MODELPARAM_VALUE.SDRAM_READ_LATENCY}
}

