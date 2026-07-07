VIVADO_PRJ_PATH ?= prj-hw/rk_zynq
VIVADO_BD_PATH ?= src/bd
HW_SPEC_PATH ?= ../sw/br/board/rk-zynq7020/spec_hw
XLNX_TLS_HW ?= /opt/Xilinx/Vivado/2019.1/bin/

.PHONY: all clean xlnx-hw-recovery clean-all ip-cores-clean
all: xlnx-hw-runbitstream xlnx-hw-export-hdf-xsa

clean-all: clean ip-cores-clean
	@rm -rfv $(VIVADO_PRJ_PATH)/$(PRJ_NAME).cache
	@rm -rfv $(VIVADO_PRJ_PATH)/$(PRJ_NAME).hw
	@rm -rfv $(VIVADO_PRJ_PATH)/$(PRJ_NAME).ip_user_files
	@rm -rfv $(VIVADO_PRJ_PATH)/$(PRJ_NAME).runs
	@rm -rfv $(VIVADO_PRJ_PATH)/$(PRJ_NAME).srcs
	@rm -rfv $(VIVADO_PRJ_PATH)/$(PRJ_NAME).sim
	@rm -rfv $(VIVADO_PRJ_PATH)/$(PRJ_NAME).gen
	@rm -rfv $(VIVADO_PRJ_PATH)/*.wcfg
	@rm -rfv $(VIVADO_PRJ_PATH)/*.xpr
	@rm -rfv $(VIVADO_PRJ_PATH)

ip-cores-clean:
	@find ip-cores \( \
		-name "*.cache" -o \
		-name "*.hw" -o \
		-name "*.ip_user_files" -o \
		-name "*.runs" -o \
		-name "*.srcs" -o \
		-name "*.sim" -o \
		-name "*.gen" -o \
		-name "*.log" -o \
		-name "*.jou" -o \
		-name "*.wcfg" \
	\) -exec rm -rfv {} +

clean:
	rm -rfv *.log *.jou .Xil/ NA/

.PHONY: xlnx-hw-runbitstream xlnx-hw-export-hdf-xsa xlnx-hw-blockdesignsave xlnx-hw-blockdesign-recovery
xlnx-hw-runbitstream:
	$(XLNX_TLS_HW)/vivado -mode tcl -source scripts/tcl/runbitstream-hw.tcl -tclargs \
		-p "$(VIVADO_PRJ_PATH)"
	rm -rfv *.log *.jou .Xil/ NA/
xlnx-hw-export: 
	rm -rfv "$(HW_SPEC_PATH)/*.hdf" "$(HW_SPEC_PATH)/*.xsa" "$(HW_SPEC_PATH)/*.bit"
	$(XLNX_TLS_HW)/vivado -mode tcl -source scripts/tcl/export-hw.tcl -tclargs \
		-p "$(VIVADO_PRJ_PATH)" -e "$(HW_SPEC_PATH)"
	rm -rfv *.log *.jou .Xil/ NA/
xlnx-hw-blockdesign-recovery:
	$(XLNX_TLS_HW)/vivado -mode tcl -source scripts/tcl/recovery-bd.tcl -tclargs \
		-p "$(VIVADO_PRJ_PATH)" -b "$(VIVADO_BD_PATH)"
	rm -rfv *.log *.jou .Xil/ NA/

.PHONY: $(PRJ_RECOVERY_TCL)
# LIST_PRJ_RECOVERY := $(wildcard prj-hw/*.tcl)
PRJ_RECOVERY_TCL := $(notdir $(VIVADO_PRJ_PATH).tcl)
xlnx-hw-prj-recovery: $(PRJ_RECOVERY_TCL)
$(PRJ_RECOVERY_TCL):
	@cd $(dir $(VIVADO_PRJ_PATH)) && \
		$(XLNX_TLS_HW)/vivado -mode batch -source $(PRJ_RECOVERY_TCL) && \
		rm -rfv *.log *.jou .Xil/ NA/
