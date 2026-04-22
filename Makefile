CUR_DIR_PRJ := $(shell pwd)

define import-br2-variable
$(eval $(1) := $(shell grep '^$(1)=' sw/br/output/.config 2>/dev/null | cut -d'=' -f2- | tr -d '"' | xargs))
endef
$(eval $(call import-br2-variable,BR2_TARGET_GENERIC_HOSTNAME))
ifneq ($(wildcard sw/br/output/.config),)
ifndef BR2_TARGET_GENERIC_HOSTNAME
    $(error BR2_TARGET_GENERIC_HOSTNAME не определена!)
endif
endif
#---------------------------------------------------------------------------------------------------------------
NAME_BOARD ?= $(BR2_TARGET_GENERIC_HOSTNAME)
SDK_PRJ_WKSP ?= $(CUR_DIR_PRJ)/sw/br/board/$(NAME_BOARD)/spec_hw
FSBL_SDK ?= mb_bootloader
FSBL_BSP_SDK ?= $(FSBL_SDK)_bsp
HW_PLATFORM ?= hw_platform_0
PRJ_DEVICE_TREE ?= device_tree_bsp_0
#---------------------------------------------------------------------------------------------------------------
PATH_HW_PRJ ?= $(CUR_DIR_PRJ)/hw/prj_hw
NAME_HW_PRJ ?= artix
NAME_BD ?= topdesign
PATH_EXPORT_HDF ?= $(SDK_PRJ_WKSP)
#---------------------------------------------------------------------------------------------------------------
QSPI_OFFSET_BOOT_SCR ?= 0x100000
QSPI_OFFSET_BISTREAM ?= 0x104000
QSPI_OFFSET_IMAGE ?= 0x284000
#---------------------------------------------------------------------------------------------------------------
ADRES_HW_SERVER ?= 127.0.0.1
PORT_HW_SERVER ?= 3121
ADDR_IMAGE ?= 0x2004000
IP_TARGET := 192.168.4.2
UPDATE_TARGET_PATH := /mnt/boot
#---------------------------------------------------------------------------------------------------------------
PATH_SRC_BR ?= $(PTH_BR)

PATH_SRC_KL ?= $(PTH_KL_XLNX)
HASH_GIT_KL ?= d8528968a1b313254305cfdc224c39db2d7bf562

PATH_SRC_UB ?= $(PTH_UB_XLNX)
HASH_GIT_UB ?= 9ac96609da74b76d3fa932662359be51cbb80a4c
#---------------------------------------------------------------------------------------------------------------

all: hw_all sw_all

sw_all: dt_all build_br

%_defconfig:
	$(MAKE) -C sw/br PATH_SRC_BR=$(PATH_SRC_BR) $@

list_config:
	@ls -l sw/br/configs
list_board:
	@ls -l sw/br/board

build_br: 
	$(MAKE) -C sw/br \
	PATH_SRC_KL=$(PATH_SRC_KL) \
	HASH_GIT_KL=$(HASH_GIT_KL) \
	PATH_SRC_UB=$(PATH_SRC_UB) \
	HASH_GIT_UB=$(HASH_GIT_UB) \
	NAME_BOARD=$(NAME_BOARD) \
	SDK_PRJ_WKSP=$(SDK_PRJ_WKSP) \
	FSBL_SDK=$(FSBL_SDK) \
	HW_PLATFORM=$(HW_PLATFORM) \
	QSPI_OFFSET_BOOT_SCR=$(QSPI_OFFSET_BOOT_SCR) \
	QSPI_OFFSET_BISTREAM=$(QSPI_OFFSET_BISTREAM) \
	QSPI_OFFSET_IMAGE=$(QSPI_OFFSET_IMAGE) \
	build_br

sv_br: 
	$(MAKE) -C sw/br \
	PATH_SRC_UB=$(PATH_SRC_UB) \
	HASH_GIT_UB=$(HASH_GIT_UB) \
	PATH_SRC_KL=$(PATH_SRC_KL) \
	HASH_GIT_KL=$(HASH_GIT_KL) \
	sv_br
sv_kl: 
	$(MAKE) -C sw/br \
	PATH_SRC_UB=$(PATH_SRC_UB) \
	HASH_GIT_UB=$(HASH_GIT_UB) \
	PATH_SRC_KL=$(PATH_SRC_KL) \
	HASH_GIT_KL=$(HASH_GIT_KL) \
	sv_kl
sv_ub: 
	$(MAKE) -C sw/br \
	PATH_SRC_UB=$(PATH_SRC_UB) \
	HASH_GIT_UB=$(HASH_GIT_UB) \
	PATH_SRC_KL=$(PATH_SRC_KL) \
	HASH_GIT_KL=$(HASH_GIT_KL) \
	sv_ub
nc_br: 
	$(MAKE) -C sw/br PATH_SRC_BR=$(PATH_SRC_BR) nc_br
nc_ub: 
	$(MAKE) -C sw/br \
	PATH_SRC_BR=$(PATH_SRC_BR) \
	PATH_SRC_UB=$(PATH_SRC_UB) \
	HASH_GIT_UB=$(HASH_GIT_UB) \
	PATH_SRC_KL=$(PATH_SRC_KL) \
	HASH_GIT_KL=$(HASH_GIT_KL) \
	nc_ub
nc_kl: 
	$(MAKE) -C sw/br \
	PATH_SRC_BR=$(PATH_SRC_BR) \
	PATH_SRC_UB=$(PATH_SRC_UB) \
	HASH_GIT_UB=$(HASH_GIT_UB) \
	PATH_SRC_KL=$(PATH_SRC_KL) \
	HASH_GIT_KL=$(HASH_GIT_KL) \
	nc_kl
mc_br: 
	$(MAKE) -C sw/br PATH_SRC_BR=$(PATH_SRC_BR) mc_br
mc_ub: 
	$(MAKE) -C sw/br \
	PATH_SRC_BR=$(PATH_SRC_BR) \
	PATH_SRC_UB=$(PATH_SRC_UB) \
	HASH_GIT_UB=$(HASH_GIT_UB) \
	PATH_SRC_KL=$(PATH_SRC_KL) \
	HASH_GIT_KL=$(HASH_GIT_KL) \
	mc_ub
mc_kl: 
	$(MAKE) -C sw/br \
	PATH_SRC_BR=$(PATH_SRC_BR) \
	PATH_SRC_UB=$(PATH_SRC_UB) \
	HASH_GIT_UB=$(HASH_GIT_UB) \
	PATH_SRC_KL=$(PATH_SRC_KL) \
	HASH_GIT_KL=$(HASH_GIT_KL) \
	mc_kl

clean_br: 
	$(MAKE) -C sw/br \
	PATH_SRC_UB=$(PATH_SRC_UB) \
	HASH_GIT_UB=$(HASH_GIT_UB) \
	PATH_SRC_KL=$(PATH_SRC_KL) \
	HASH_GIT_KL=$(HASH_GIT_KL) \
	clean_br
#---------------------------------------------------------------------------------------------------------------
recovery_hw:
	$(MAKE) -C hw \
	NAME_BOARD=$(NAME_BOARD) \
	PATH_HW_PRJ=$(PATH_HW_PRJ) \
	NAME_HW_PRJ=$(NAME_HW_PRJ) \
	NAME_BD=$(NAME_BD) \
	PATH_EXPORT_HDF=$(PATH_EXPORT_HDF) \
	recovery_hw
hw_all:
	$(MAKE) -C hw \
	NAME_BOARD=$(NAME_BOARD) \
	PATH_HW_PRJ=$(PATH_HW_PRJ) \
	NAME_HW_PRJ=$(NAME_HW_PRJ) \
	NAME_BD=$(NAME_BD) \
	PATH_EXPORT_HDF=$(PATH_EXPORT_HDF) \
	hw_all
sv_bd: 
	$(MAKE) -C hw \
	NAME_BOARD=$(NAME_BOARD) \
	PATH_HW_PRJ=$(PATH_HW_PRJ) \
	NAME_HW_PRJ=$(NAME_HW_PRJ) \
	NAME_BD=$(NAME_BD) \
	PATH_EXPORT_HDF=$(PATH_EXPORT_HDF) \
	save_bd
export_hdf: 
	$(MAKE) -C hw \
	NAME_BOARD=$(NAME_BOARD) \
	PATH_HW_PRJ=$(PATH_HW_PRJ) \
	NAME_HW_PRJ=$(NAME_HW_PRJ) \
	NAME_BD=$(NAME_BD) \
	PATH_EXPORT_HDF=$(PATH_EXPORT_HDF) \
	export_hdf
#---------------------------------------------------------------------------------------------------------------
dt_all:
	$(MAKE) -C sw/br \
	NAME_BOARD=$(NAME_BOARD) \
	SDK_PRJ_WKSP=$(SDK_PRJ_WKSP) \
	HW_PLATFORM=$(HW_PLATFORM) \
	PRJ_DEVICE_TREE=$(PRJ_DEVICE_TREE) \
	FSBL_SDK=$(FSBL_SDK) \
	FSBL_BSP_SDK=$(FSBL_BSP_SDK) \
	QSPI_OFFSET_BOOT_SCR=$(QSPI_OFFSET_BOOT_SCR) \
	QSPI_OFFSET_BISTREAM=$(QSPI_OFFSET_BISTREAM) \
	QSPI_OFFSET_IMAGE=$(QSPI_OFFSET_IMAGE) \
	dt_all
#---------------------------------------------------------------------------------------------------------------
sd_all:
	$(MAKE) -C sw/br sd_all
sd_img:
	sudo dd if=sw/br/output/images/sdcard.img of=/dev/sda bs=4M status=progress conv=fsync
#---------------------------------------------------------------------------------------------------------------
update_remote_all: update_bootbin update_firmwarefpga update_imageub update_bootscr update_kernel update_dtb update_rootfs
update_bootbin:
	@ssh root@$(IP_TARGET) "mkdir -p $(UPDATE_TARGET_PATH)/backup"
	@ssh root@$(IP_TARGET) "cp $(UPDATE_TARGET_PATH)/BOOT.bin $(UPDATE_TARGET_PATH)/backup/BOOT.bin"
	@ssh root@$(IP_TARGET) "rm -f $(UPDATE_TARGET_PATH)/BOOT.bin"
	scp -O sw/br/output/images/BOOT.bin root@$(IP_TARGET):$(UPDATE_TARGET_PATH)/BOOT.bin
update_qspi:
	@ssh root@$(IP_TARGET) "mkdir -p $(UPDATE_TARGET_PATH)/backup"
	@ssh root@$(IP_TARGET) "cp $(UPDATE_TARGET_PATH)/QSPI.bin $(UPDATE_TARGET_PATH)/backup/QSPI.bin"
	@ssh root@$(IP_TARGET) "rm -f $(UPDATE_TARGET_PATH)/QSPI.bin"
	scp -O sw/br/output/images/QSPI.bin root@$(IP_TARGET):$(UPDATE_TARGET_PATH)/QSPI.bin
update_firmwarefpga:
	@ssh root@$(IP_TARGET) "mkdir -p $(UPDATE_TARGET_PATH)/backup"
	@ssh root@$(IP_TARGET) "cp $(UPDATE_TARGET_PATH)/firmware_fpga.bit $(UPDATE_TARGET_PATH)/backup/firmware_fpga.bit"
	@ssh root@$(IP_TARGET) "rm -f $(UPDATE_TARGET_PATH)/firmware_fpga.bit"
	scp -O sw/br/output/images/firmware_fpga.bit root@$(IP_TARGET):$(UPDATE_TARGET_PATH)/firmware_fpga.bit
update_imageub:
	@ssh root@$(IP_TARGET) "mkdir -p $(UPDATE_TARGET_PATH)/backup"
	@ssh root@$(IP_TARGET) "cp $(UPDATE_TARGET_PATH)/image.ub $(UPDATE_TARGET_PATH)/backup/image.ub"
	@ssh root@$(IP_TARGET) "rm -f $(UPDATE_TARGET_PATH)/image.ub"
	scp -O sw/br/output/images/image.ub root@$(IP_TARGET):$(UPDATE_TARGET_PATH)/image.ub
update_bootscr:
	@ssh root@$(IP_TARGET) "mkdir -p $(UPDATE_TARGET_PATH)/backup"
	@ssh root@$(IP_TARGET) "cp $(UPDATE_TARGET_PATH)/boot.scr $(UPDATE_TARGET_PATH)/backup/boot.scr"
	@ssh root@$(IP_TARGET) "rm -f $(UPDATE_TARGET_PATH)/boot.scr"
	scp -O sw/br/output/images/boot.scr root@$(IP_TARGET):$(UPDATE_TARGET_PATH)/boot.scr
update_kernel:
	@ssh root@$(IP_TARGET) "mkdir -p $(UPDATE_TARGET_PATH)/backup"
	@ssh root@$(IP_TARGET) "cp $(UPDATE_TARGET_PATH)/uImage $(UPDATE_TARGET_PATH)/backup/uImage"
	@ssh root@$(IP_TARGET) "rm -f $(UPDATE_TARGET_PATH)/uImage"
	scp -O sw/br/output/images/uImage root@$(IP_TARGET):$(UPDATE_TARGET_PATH)/uImage
update_dtb:
	@ssh root@$(IP_TARGET) "mkdir -p $(UPDATE_TARGET_PATH)/backup"
	@ssh root@$(IP_TARGET) "cp $(UPDATE_TARGET_PATH)/devicetree.dtb $(UPDATE_TARGET_PATH)/backup/devicetree.dtb"
	@ssh root@$(IP_TARGET) "rm -f $(UPDATE_TARGET_PATH)/devicetree.dtb"
	scp -O sw/br/output/images/devicetree.dtb root@$(IP_TARGET):$(UPDATE_TARGET_PATH)/devicetree.dtb
update_rootfs:
	@ssh root@$(IP_TARGET) "mkdir -p $(UPDATE_TARGET_PATH)/backup"
	@ssh root@$(IP_TARGET) "cp $(UPDATE_TARGET_PATH)/uramdisk.image $(UPDATE_TARGET_PATH)/backup/uramdisk.image"
	@ssh root@$(IP_TARGET) "rm -f $(UPDATE_TARGET_PATH)/uramdisk.image"
	scp -O sw/br/output/images/uramdisk.image root@$(IP_TARGET):$(UPDATE_TARGET_PATH)/uramdisk.image
#---------------------------------------------------------------------------------------------------------------
boot_ram:
	$(MAKE) -C sw/br NAME_BOARD=$(NAME_BOARD) \
	ADRES_HW_SERVER=$(ADRES_HW_SERVER) \
	PORT_HW_SERVER=$(PORT_HW_SERVER) \
	ADDRESS_IMAGE=$(ADDR_IMAGE) program_ram
dow_bootin:
	$(MAKE) -C sw/br NAME_BOARD=$(NAME_BOARD) \
	ADRES_HW_SERVER=$(ADRES_HW_SERVER) \
	PORT_HW_SERVER=$(PORT_HW_SERVER) \
	ADDRESS_IMAGE=$(ADDR_IMAGE) dow_bootin
reset_board:
	$(MAKE) -C sw/br NAME_BOARD=$(NAME_BOARD) \
	ADRES_HW_SERVER=$(ADRES_HW_SERVER) \
	PORT_HW_SERVER=$(PORT_HW_SERVER) reset_board
program_qspi: 
	$(MAKE) -C sw/br NAME_BOARD=$(NAME_BOARD) \
	ADRES_HW_SERVER=$(ADRES_HW_SERVER) \
	PORT_HW_SERVER=$(PORT_HW_SERVER) program_qspi

#---------------------------------------------------------------------------------------------------------------
sdk_all:
	$(MAKE) -C sw/br \
	NAME_BOARD=$(NAME_BOARD) \
	SDK_PRJ_WKSP=$(SDK_PRJ_WKSP) \
	FSBL_SDK=$(FSBL_SDK) \
	FSBL_BSP_SDK=$(FSBL_BSP_SDK) \
	HW_PLATFORM=$(HW_PLATFORM) \
	PRJ_DEVICE_TREE=$(PRJ_DEVICE_TREE) \
	sdk_all
