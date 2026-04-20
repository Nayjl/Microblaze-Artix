NAME_BOARD ?= qmtechz10
PATH_HW_PRJ ?= prj_hw
NAME_HW_PRJ ?= qmtech_lnx
NAME_BD ?= topdesign
PATH_EXPORT_HDF ?= ../sw/br/board/$(NAME_BOARD)/spec_hw

all: hw_all

hw_all: run_bitstream export_hdf

recovery_hw:
	export NAME_BOARD=$(NAME_BOARD) && \
	export PATH_HW_PRJ=$(PATH_HW_PRJ) && \
	export NAME_HW_PRJ=$(NAME_HW_PRJ) && \
	export NAME_BD=$(NAME_BD) && \
	export PATH_EXPORT_HDF=$(PATH_EXPORT_HDF) && \
	vivado -mode tcl -source scripts/tcl/assembly_prj_hw.tcl
	rm -rfv *.log *.jou .Xil/ NA/

clean:
	rm -rfv *.log *.jou .Xil/ NA/

FULL_PATH_HW_PRJ := $(PATH_HW_PRJ)/$(NAME_HW_PRJ)
PRJ_XPR_VIVADO := $(FULL_PATH_HW_PRJ)/$(NAME_HW_PRJ).xpr
SAVE_BLOCK_DESIGN := $(FULL_PATH_HW_PRJ)/$(NAME_BD).tcl
SYSDEF_FILE_HDF := $(FULL_PATH_HW_PRJ)/$(NAME_HW_PRJ).runs/impl_1/topmodule.sysdef
run_bitstream:
	@echo "open_project $(PRJ_XPR_VIVADO)" > $@.tcl
	@echo "update_compile_order -fileset sources_1" >> $@.tcl
	@echo "reset_run synth_1" >> $@.tcl
	@echo "launch_runs impl_1 -to_step write_bitstream -jobs $(shell nproc)" >> $@.tcl
	@echo "wait_on_run impl_1" >> $@.tcl
	@echo "update_compile_order -fileset sources_1" >> $@.tcl
	@echo "close_project" >> $@.tcl
	@echo "exit" >> $@.tcl
	vivado -mode tcl -source $@.tcl
	rm -rfv *.log *.jou .Xil/ NA/ $@.tcl
export_hdf: 
	@echo "open_project $(PRJ_XPR_VIVADO)" > $@.tcl
	@echo "update_compile_order -fileset sources_1" >> $@.tcl
	@echo "wait_on_run impl_1" >> $@.tcl
	@echo "update_compile_order -fileset sources_1" >> $@.tcl
	@echo "file copy -force $(SYSDEF_FILE_HDF) $(PATH_EXPORT_HDF)/topmodule.hdf" >> $@.tcl
	@echo "update_compile_order -fileset sources_1" >> $@.tcl
	@echo "close_project" >> $@.tcl
	@echo "exit" >> $@.tcl
	vivado -mode tcl -source $@.tcl
	rm -rfv *.log *.jou .Xil/ NA/ $@.tcl
save_bd:
	@echo "open_project $(PRJ_XPR_VIVADO)" > $@.tcl
	@echo "update_compile_order -fileset sources_1" >> $@.tcl
	@echo "open_bd_design {$(PTH_BD_SRC)}" >> $@.tcl
	@echo "update_compile_order -fileset sources_1" >> $@.tcl
	@echo "write_bd_tcl -force $(SAVE_BLOCK_DESIGN)" >> $@.tcl
	@echo "update_compile_order -fileset sources_1" >> $@.tcl
	@echo "close_bd_design [get_bd_designs $(NAME_BD)]" >> $@.tcl
	@echo "update_compile_order -fileset sources_1" >> $@.tcl
	@echo "close_project" >> $@.tcl
	@echo "exit" >> $@.tcl
	vivado -mode tcl -source $@.tcl
	rm -rfv *.log *.jou .Xil/ NA/ $@.tcl
PTH_BD_WRAPER := $(FULL_PATH_HW_PRJ)/$(NAME_HW_PRJ).srcs/sources_1/bd/$(NAME_BD)/hdl/$(NAME_BD)_wrapper.v
PTH_BD_SRC := $(FULL_PATH_HW_PRJ)/$(NAME_HW_PRJ).srcs/sources_1/bd/$(NAME_BD)/$(NAME_BD).bd
recovery_bd: 
	@echo "open_project $(PRJ_XPR_VIVADO)" > $@.tcl
	@echo "update_compile_order -fileset sources_1" >> $@.tcl
	@echo "export_ip_user_files -of_objects [get_files $(PTH_BD_WRAPER)] -no_script -reset -force -quiet" >> $@.tcl
	@echo "export_ip_user_files -of_objects [get_files $(PTH_BD_SRC)] -no_script -reset -force -quiet" >> $@.tcl
	@echo "update_compile_order -fileset sources_1" >> $@.tcl
	@echo "remove_files -of_objects [get_files $(PTH_BD_WRAPER)] -no_script -reset -force -quiet" >> $@.tcl
	@echo "remove_files -of_objects [get_files $(PTH_BD_SRC)] -no_script -reset -force -quiet" >> $@.tcl
	@echo "file delete -force [get_files $(PTH_BD_WRAPER)] -no_script -reset -force -quiet" >> $@.tcl
	@echo "file delete -force [get_files $(PTH_BD_SRC)] -no_script -reset -force -quiet" >> $@.tcl
	@echo "update_compile_order -fileset sources_1" >> $@.tcl
	@echo "source $(SAVE_BLOCK_DESIGN)" >> $@.tcl
	@echo "update_compile_order -fileset sources_1" >> $@.tcl
	@echo "close_project" >> $@.tcl
	@echo "exit" >> $@.tcl
	vivado -mode tcl -source $@.tcl
	rm -rfv *.log *.jou .Xil/ NA/ $@.tcl


