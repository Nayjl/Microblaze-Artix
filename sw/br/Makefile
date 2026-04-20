CUR_DIR_BR := $(shell pwd)
NAME_BOARD ?= qmtechz10
SDK_PRJ_WKSP ?= board/$(NAME_BOARD)/spec_hw
FSBL_SDK ?= fsbl
FSBL_BSP_SDK ?= $(FSBL_SDK)_bsp
HW_PLATFORM ?= hw_platform_0
PRJ_DEVICE_TREE ?= device_tree_bsp_0


PATH_NAME_BOARD := board/$(NAME_BOARD)
HARDWARE_SPECIFICATION_PATH := $(SDK_PRJ_WKSP)
HARDWARE_SPECIFICATION_HW_PATH := $(HARDWARE_SPECIFICATION_PATH)/$(HW_PLATFORM)
HARDWARE_SPECIFICATION_FSBL_PATH := $(HARDWARE_SPECIFICATION_PATH)/$(FSBL_SDK)
HARDWARE_SPECIFICATION_FSBL_BSP_PATH := $(HARDWARE_SPECIFICATION_PATH)/$(FSBL_BSP_SDK)
HARDWARE_SPECIFICATION_DTS_PATH := $(HARDWARE_SPECIFICATION_PATH)/$(PRJ_DEVICE_TREE)

QSPI_OFFSET_BOOT_SCR ?= 0x11D000
QSPI_OFFSET_BISTREAM ?= 0x11F000
QSPI_OFFSET_IMAGE ?= 0x21F000

PATH_SRC_BR ?= $(PTH_BR)

PATH_SRC_KL ?= $(PTH_KL_XLNX)
HASH_GIT_KL ?= d8528968a1b313254305cfdc224c39db2d7bf562

PATH_SRC_UB ?= $(PTH_UB_XLNX)
HASH_GIT_UB ?= 9ac96609da74b76d3fa932662359be51cbb80a4c

all: dt_all build_br

build_br: conf_uboot
	$(MAKE) -C output \
	PATH_SRC_KL=$(PATH_SRC_KL) \
	HASH_GIT_KL=$(HASH_GIT_KL) \
	PATH_SRC_UB=$(PATH_SRC_UB) \
	HASH_GIT_UB=$(HASH_GIT_UB) \
	NAME_BOARD=$(NAME_BOARD) \
	HARDWARE_SPECIFICATION_HW_PATH=$(HARDWARE_SPECIFICATION_HW_PATH) \
	HARDWARE_SPECIFICATION_FSBL_PATH=$(HARDWARE_SPECIFICATION_FSBL_PATH) \
	QSPI_OFFSET_BOOT_SCR=$(QSPI_OFFSET_BOOT_SCR) \
	QSPI_OFFSET_BISTREAM=$(QSPI_OFFSET_BISTREAM) \
	QSPI_OFFSET_IMAGE=$(QSPI_OFFSET_IMAGE)

%_defconfig:
	@mkdir -p output
	$(MAKE) -C $(PATH_SRC_BR) BR2_EXTERNAL=$(CUR_DIR_BR) O=$(CUR_DIR_BR)/output $@

list_config:
	@ls -l configs
list_board:
	@ls -l board

sv_br: 
	$(MAKE) -C output \
	PATH_SRC_UB=$(PATH_SRC_UB) \
	HASH_GIT_UB=$(HASH_GIT_UB) \
	PATH_SRC_KL=$(PATH_SRC_KL) \
	HASH_GIT_KL=$(HASH_GIT_KL) \
	savedefconfig
sv_kl: 
	$(MAKE) -C output \
	PATH_SRC_UB=$(PATH_SRC_UB) \
	HASH_GIT_UB=$(HASH_GIT_UB) \
	PATH_SRC_KL=$(PATH_SRC_KL) \
	HASH_GIT_KL=$(HASH_GIT_KL) \
	linux-update-config
sv_ub: 
	$(MAKE) -C output \
	PATH_SRC_UB=$(PATH_SRC_UB) \
	HASH_GIT_UB=$(HASH_GIT_UB) \
	PATH_SRC_KL=$(PATH_SRC_KL) \
	HASH_GIT_KL=$(HASH_GIT_KL) \
	uboot-update-config

nc_br: 
	$(MAKE) -C $(PATH_SRC_BR) O=$(CUR_DIR_BR)/output nconfig
nc_ub: 
	$(MAKE) -C $(PATH_SRC_BR) \
	O=$(CUR_DIR_BR)/output \
	PATH_SRC_UB=$(PATH_SRC_UB) \
	HASH_GIT_UB=$(HASH_GIT_UB) \
	PATH_SRC_KL=$(PATH_SRC_KL) \
	HASH_GIT_KL=$(HASH_GIT_KL) \
	uboot-nconfig
nc_kl: 
	$(MAKE) -C $(PATH_SRC_BR) \
	O=$(CUR_DIR_BR)/output \
	PATH_SRC_UB=$(PATH_SRC_UB) \
	HASH_GIT_UB=$(HASH_GIT_UB) \
	PATH_SRC_KL=$(PATH_SRC_KL) \
	HASH_GIT_KL=$(HASH_GIT_KL) \
	linux-nconfig
mc_br: 
	$(MAKE) -C $(PATH_SRC_BR) O=$(CUR_DIR_BR)/output menuconfig
mc_ub: 
	$(MAKE) -C $(PATH_SRC_BR) \
	O=$(CUR_DIR_BR)/output \
	PATH_SRC_UB=$(PATH_SRC_UB) \
	HASH_GIT_UB=$(HASH_GIT_UB) \
	PATH_SRC_KL=$(PATH_SRC_KL) \
	HASH_GIT_KL=$(HASH_GIT_KL) \
	uboot-menuconfig
mc_kl: 
	$(MAKE) -C $(PATH_SRC_BR) \
	O=$(CUR_DIR_BR)/output \
	PATH_SRC_UB=$(PATH_SRC_UB) \
	HASH_GIT_UB=$(HASH_GIT_UB) \
	PATH_SRC_KL=$(PATH_SRC_KL) \
	HASH_GIT_KL=$(HASH_GIT_KL) \
	linux-menuconfig
xc_br: 
	$(MAKE) -C $(PATH_SRC_BR) O=$(CUR_DIR_BR)/output xconfig
xc_ub: 
	$(MAKE) -C $(PATH_SRC_BR) \
	O=$(CUR_DIR_BR)/output \
	PATH_SRC_UB=$(PATH_SRC_UB) \
	HASH_GIT_UB=$(HASH_GIT_UB) \
	PATH_SRC_KL=$(PATH_SRC_KL) \
	HASH_GIT_KL=$(HASH_GIT_KL) \
	uboot-xconfig
xc_kl: 
	$(MAKE) -C $(PATH_SRC_BR) \
	O=$(CUR_DIR_BR)/output \
	PATH_SRC_UB=$(PATH_SRC_UB) \
	HASH_GIT_UB=$(HASH_GIT_UB) \
	PATH_SRC_KL=$(PATH_SRC_KL) \
	HASH_GIT_KL=$(HASH_GIT_KL) \
	linux-xconfig

cr_fs_dir: 
	mkdir -p board/$(NAME_BOARD)/rootfs_overlay
	mkdir -p configs
	mkdir -p package
	mkdir -p output
	touch -fv Config.in
	touch -fv external.desc
	touch -fv external.mk
clean_br: 
	$(MAKE) -C output \
	PATH_SRC_UB=$(PATH_SRC_UB) \
	HASH_GIT_UB=$(HASH_GIT_UB) \
	PATH_SRC_KL=$(PATH_SRC_KL) \
	HASH_GIT_KL=$(HASH_GIT_KL) \
	clean
	@rm -rfv output

conf_uboot: 
	@echo 'CONFIG_BOOTCOMMAND="mmc dev 0 && fatload mmc 0 0x2000000 boot.scr && source 0x2000000"' > board/$(NAME_BOARD)/uboot-fragment.cfg
#---------------------------------------------------------------------------------------------------------------
dt_all: sdk_all dts_compile dtb_compile
dts_compile: 
	gcc -E -nostdinc \
	-undef -D__DTS__ \
	-D QSPI_OFFSET_BOOT_SCR=$(QSPI_OFFSET_BOOT_SCR) \
    -D QSPI_OFFSET_BISTREAM=$(QSPI_OFFSET_BISTREAM) \
    -D QSPI_OFFSET_IMAGE=$(QSPI_OFFSET_IMAGE) \
	-x assembler-with-cpp \
	-I $(HARDWARE_SPECIFICATION_DTS_PATH) \
	$(HARDWARE_SPECIFICATION_PATH)/user_top.dts \
	-o $(HARDWARE_SPECIFICATION_PATH)/devicetree.dts
dtb_compile:
	@mkdir -p output/images
	dtc -I dts -O dtb \
	-o output/images/devicetree.dtb $(HARDWARE_SPECIFICATION_PATH)/devicetree.dts
#---------------------------------------------------------------------------------------------------------------

#---------------------------------------------------------------------------------------------------------------
sd_all: boot_cp_sd rootfs_cp_sd
clean_sd_ext4: 
	sudo rm -rfv /media/$(USER)/rootfs/*
rootfs_cp_sd: clean_sd_ext4
	sudo tar -C /media/$(USER)/rootfs -xvf output/images/rootfs.tar.gz
clean_sd_fat:
	rm -rfv /media/$(USER)/BOOT/*
boot_cp_sd: 
	cp -fv output/images/BOOT.bin /media/$(USER)/BOOT
	cp -fv output/images/boot.scr /media/$(USER)/BOOT
	cp -fv output/images/firmware_fpga.bit /media/$(USER)/BOOT
	cp -fv output/images/uImage /media/$(USER)/BOOT
	cp -fv output/images/devicetree.dtb /media/$(USER)/BOOT
	cp -fv output/images/uramdisk.image /media/$(USER)/BOOT/uramdisk.image
	cp -fv output/images/image.ub /media/$(USER)/BOOT
#---------------------------------------------------------------------------------------------------------------


#---------------------------------------------------------------------------------------------------------------

ADRES_HW_SERVER ?= 127.0.0.1
PORT_HW_SERVER ?= 3121
ADDRESS_IMAGE ?= 0x2004000
program_ram: 
	xsct board/$(NAME_BOARD)/scripts/tcl/program_ram.tcl $(ADRES_HW_SERVER) $(PORT_HW_SERVER) $(ADDRESS_IMAGE)
run_board_ram: 
	xsct board/$(NAME_BOARD)/scripts/tcl/run_board_ram.tcl $(ADRES_HW_SERVER) $(PORT_HW_SERVER) $(ADDRESS_IMAGE)
dow_bootin:
	xsct board/$(NAME_BOARD)/scripts/tcl/download_bootbin.tcl $(ADRES_HW_SERVER) $(PORT_HW_SERVER) $(ADDRESS_IMAGE)
reset_board:
	xsct board/$(NAME_BOARD)/scripts/tcl/reset_board.tcl $(ADRES_HW_SERVER) $(PORT_HW_SERVER)
program_qspi:
	xsct board/$(NAME_BOARD)/scripts/tcl/open_hw_server.tcl $(ADRES_HW_SERVER) $(PORT_HW_SERVER)
	program_flash -offset 0 \
	-flash_type qspi-x4-single \
	-fsbl output/images/fsbl.elf \
	-f output/images/QSPI.bin \
	-url tcp:$(ADRES_HW_SERVER):$(PORT_HW_SERVER)

#---------------------------------------------------------------------------------------------------------------
sdk_all: build_sdk_prj
build_sdk_prj: 
	export NM_HW_PLATFORM=$(HW_PLATFORM) && \
	export NM_PRJ_FSBL=$(FSBL_SDK) && \
	export NM_PRJ_FSBL_BSP=$(FSBL_BSP_SDK) && \
	export NM_PRJ_DEVICE_TREE=$(PRJ_DEVICE_TREE) && \
	xsct board/$(NAME_BOARD)/scripts/tcl/crt_sdk_prj.tcl $(HARDWARE_SPECIFICATION_PATH)
#---------------------------------------------------------------------------------------------------------------

