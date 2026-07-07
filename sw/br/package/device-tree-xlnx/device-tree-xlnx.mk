
DEVICE_TREE_XLNX_VERSION = $(subst ",,$(BR2_PACKAGE_VER_DEVICETREE_XLNX))
DEVICE_TREE_XLNX_SITE = $(call github,Xilinx,device-tree-xlnx,$(DEVICE_TREE_XLNX_VERSION))
# DEVICE_TREE_XLNX_INSTALL_HOST = NO
HOST_DEVICE_TREE_XLNX_DEPENDENCIES = host-dtc
# ARM_TRUSTED_FIRMWARE_DEPENDENCIES += host-device-tree-xlnx
# UBOOT_DEPENDENCIES += host-device-tree-xlnx
ARM_TRUSTED_FIRMWARE_PRE_CONFIGURE_HOOKS += DEVICE_TREE_XLNX_ENSURE_BUILT
UBOOT_PRE_CONFIGURE_HOOKS += DEVICE_TREE_XLNX_ENSURE_BUILT

define DEVICE_TREE_XLNX_ENSURE_BUILT
    $(MAKE) -C $(BR2_EXTERNAL_OVERLAY_PKGS_PATH)/output host-device-tree-xlnx
endef

ifeq ($(BR2_PACKAGE_SERIAS_XLNX_CHIP_ZYNQ),y)
DEVICE_TREE_XLNX_SERIES = "Zynq"
else ifeq ($(BR2_PACKAGE_SERIAS_XLNX_CHIP_ZYNQMP),y)
DEVICE_TREE_XLNX_SERIES = "Zynqmp"
else ifeq ($(BR2_PACKAGE_SERIAS_XLNX_CHIP_MICROBLAZE),y)
DEVICE_TREE_XLNX_SERIES = "Microblaze"
else
DEVICE_TREE_XLNX_SERIES = "Zynq"
endif

DEVICE_TREE_XLNX_XSCT = $(subst ",,$(BR2_PACKAGE_XLNX_TOOLS_SW)/xsct)

define DEVICE_TREE_XLNX_CREATE_PRJ
	$(DEVICE_TREE_XLNX_XSCT) -eval \
		"source $(HOST_DEVICE_TREE_XLNX_PKGDIR)build_script.tcl; build_dts \
		-version $(subst ",,$(BR2_PACKAGE_XLNX_TOOLS_VERSION)) \
		-repo $(@D) \
		-serias $(DEVICE_TREE_XLNX_SERIES) \
		-hwpth $(subst ",,$(BR2_PACKAGE_XLNX_HW_SPECIFIED))"
endef

DEVICE_TREE_SRCPRJ = $(subst ",,$(BR2_PACKAGE_XLNX_HW_SPECIFIED))

ifeq ($(BR2_PACKAGE_DEVICETREE_XLNX_EN_OVERLAY),y)
define DEVICE_TREE_XLNX_COMPILE_PRJ
	gcc -E -nostdinc -undef -D__DTS__ -x assembler-with-cpp \
		-I $(DEVICE_TREE_SRCPRJ)/device-tree \
		$(subst ",,$(BR2_PACKAGE_DEVICETREE_XLNX_OVERLAY)) \
		-o $(DEVICE_TREE_SRCPRJ)/devicetree.dts
endef
else
define DEVICE_TREE_XLNX_COMPILE_PRJ
	gcc -E -nostdinc -undef -D__DTS__ -x assembler-with-cpp \
		-I $(DEVICE_TREE_SRCPRJ)/device-tree \
		$(DEVICE_TREE_SRCPRJ)/device-tree/system-top.dts \
		-o $(DEVICE_TREE_SRCPRJ)/devicetree.dts
endef
endif

ifeq ($(BR2_PACKAGE_DEVICETREE_XLNX_TO_BLOB), y)
define DEVICE_TREE_XLNX_BUILD_BLOB
	dtc -I dts -O dtb \
		-o $(BINARIES_DIR)/devicetree.dtb \
        $(DEVICE_TREE_SRCPRJ)/devicetree.dts
endef
endif

define HOST_DEVICE_TREE_XLNX_BUILD_CMDS
	$(DEVICE_TREE_XLNX_CREATE_PRJ)
	$(DEVICE_TREE_XLNX_COMPILE_PRJ)
endef

define HOST_DEVICE_TREE_XLNX_INSTALL_CMDS
	$(DEVICE_TREE_XLNX_BUILD_BLOB)
endef

$(eval $(host-generic-package))

