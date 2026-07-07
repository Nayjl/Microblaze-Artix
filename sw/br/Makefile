CUR_DIR_BR := $(shell pwd)
#---------------------------------------------------------------------------------------------------------------
PATH_SRC_BR ?= "/home/$(USER)/work/repo_xlnx/br2026/buildroot"
VERSION_BR ?= "2024.02.1"
#---------------------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------------------
.PHONY: all buildroot-build list-defconfigs
all: buildroot-build

buildroot-build:
	$(MAKE) -C output 
.PHONY: %_defconfig
%_defconfig: repositories-buildroot-switch
	@mkdir -p output
	@$(MAKE) -C $(PATH_SRC_BR) \
		BR2_EXTERNAL=$(CUR_DIR_BR) \
		O=$(CUR_DIR_BR)/output $@
list-defconfigs: repositories-buildroot-switch
	@$(MAKE) -C $(PATH_SRC_BR) \
		BR2_EXTERNAL=$(CUR_DIR_BR) \
		O=$(CUR_DIR_BR)/output $@
defconfig: repositories-buildroot-switch
	@$(MAKE) -C $(PATH_SRC_BR) \
		BR2_EXTERNAL=$(CUR_DIR_BR) \
		O=$(CUR_DIR_BR)/output defconfig
#---------------------------------------------------------------------------------------------------------------
.PHONY: buildroot-help
buildroot-help:
	$(MAKE) -C output \
		help
#---------------------------------------------------------------------------------------------------------------
.PHONY: buildroot-cmd-%
buildroot-cmd-%:
	$(MAKE) -C output $*
#---------------------------------------------------------------------------------------------------------------
.PHONY: buildroot-saveconfig linux-saveconfig uboot-saveconfig
buildroot-saveconfig:
	$(MAKE) -C output savedefconfig
linux-saveconfig:
	$(MAKE) -C output \
		linux-update-defconfig
uboot-saveconfig:
	$(MAKE) -C output \
		uboot-update-defconfig

.PHONY: buildroot-fullsaveconfig linux-fullsaveconfig uboot-fullsaveconfig
buildroot-fullsaveconfig:
	$(MAKE) -C output savedefconfig
linux-fullsaveconfig:
	$(MAKE) -C output \
		linux-update-config
uboot-fullsaveconfig:
	$(MAKE) -C output \
		uboot-update-config
#---------------------------------------------------------------------------------------------------------------
.PHONY: buildroot-nconfig uboot-nconfig linux-nconfig
buildroot-nconfig: 
	$(MAKE) -C output \
		nconfig
uboot-nconfig: 
	$(MAKE) -C output \
		uboot-nconfig
linux-nconfig:
	$(MAKE) -C output \
		linux-nconfig
#---------------------------------------------------------------------------------------------------------------
.PHONY: buildroot-menuconfig uboot-menuconfig linux-menuconfig
buildroot-menuconfig:
	$(MAKE) -C output \
		menuconfig
uboot-menuconfig: 
	$(MAKE) -C output \
		uboot-menuconfig
linux-menuconfig: 
	$(MAKE) -C output \
		linux-menuconfig
#---------------------------------------------------------------------------------------------------------------
.PHONY: buildroot-xconfig uboot-xconfig linux-xconfig
buildroot-xconfig:
	$(MAKE) -C output \
		xconfig
uboot-xconfig: 
	$(MAKE) -C output \
		uboot-xconfig
linux-xconfig: 
	$(MAKE) -C output \
		linux-xconfig
#---------------------------------------------------------------------------------------------------------------
.PHONY: buildroot-clean
buildroot-clean:
	@rm -rfv output
# conf_uboot: 
# 	@echo 'CONFIG_BOOTCOMMAND="setenv addr_uscr 0x2000000; mmc dev 0 && fatload mmc 0 $${addr_uscr} boot.scr && source $${addr_uscr}; mmc dev 1 && fatload mmc 1 $${addr_uscr} boot.scr && source $${addr_uscr}; sf probe 0 0 0 && sf read $${addr_uscr} $(QSPI_OFFSET_BOOT_SCR) 0x40000 && source $${addr_uscr}"' > board/$(NAME_BOARD)/uboot-fragment.cfg
#---------------------------------------------------------------------------------------------------------------
.PHONY: repositories-buildroot-switch
repositories-buildroot-switch:
	@if [ ! -d "$(PATH_SRC_BR)" ]; then \
		echo ">>>>> Cloning $(PATH_SRC_BR)"; \
		git clone https://gitlab.com/buildroot.org/buildroot.git $(PATH_SRC_BR); \
		echo ">>>>> End cloning $(PATH_SRC_BR)"; \
		exit 1; \
	fi
	git -C $(PATH_SRC_BR) checkout $(VERSION_BR)
#---------------------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------------------
# .PHONY: program-qspi program-ram
# program-qspi:
# 	$(TOOLS_XILINX_SW)/$(VERSION_XILINX)/bin/xsct -eval \
# 		"source board/$(NAME_BOARD)/xsct_script.tcl; open_hw_server \
# 		-ip_addr $(ADRES_HW_SERVER) \
# 		-port $(PORT_HW_SERVER) \
# 		-xlnx_sw $(TOOLS_XILINX_SW)/$(VERSION_XILINX)/bin/program_flash \
# 		-fsbl output/images/fsbl.elf \
# 		-file output/images/QSPI.bin"	
# program-ram:
# 	$(TOOLS_XILINX_SW)/$(VERSION_XILINX)/bin/xsct -eval \
# 		"source board/$(NAME_BOARD)/xsct_script.tcl; dow_data \
# 		-ip_addr $(ADRES_HW_SERVER) \
# 		-port $(PORT_HW_SERVER) \
# 		-serias $(SERIAS_CHIP) \
# 		-file output/images/image.ub \
# 		-addr_image $(ADDRESS_IMAGE) \
# 		-uboot output/images/u-boot.elf
# 		-ps_init output/images/ps_init.tcl
# 		-bitstream output/images/firmware_fpga.bit
#---------------------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------------------
