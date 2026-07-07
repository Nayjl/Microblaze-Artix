#!/bin/sh
# -------------------------------------------------------------------------------------------------------------------
set -e
TOP_DIR="$(dirname "$0")"
# -------------------------------------------------------------------------------------------------------------------
# rm -rfv $BR2_EXTERNAL_CUSTOM_PACKAGE_PATH/board/$BR2_TARGET_GENERIC_HOSTNAME/hw-spec/ps* \
# 		$BR2_EXTERNAL_CUSTOM_PACKAGE_PATH/board/$BR2_TARGET_GENERIC_HOSTNAME/hw-spec/*.bit
# 
# $TOOLS_XILINX_SW/$VERSION_XILINX/bin/xsct -eval \
# 		"source $TOP_DIR/xsct_script.tcl; build_all \
# 		-version $VERSION_XILINX \
# 		-repo_embsw $REPOS_EMBEDDEDSW_XILINX \
# 		-repo_dtx $REPOS_DEVICETREE_XILINX \
# 		-serias $SERIAS_CHIP \
# 		-hwpth $BR2_EXTERNAL_CUSTOM_PACKAGE_PATH/board/$BR2_TARGET_GENERIC_HOSTNAME/hw-spec"
# -------------------------------------------------------------------------------------------------------------------
# gcc -E -nostdinc \
# 		-undef -D__DTS__ \
# 		-D QSPI_OFFSET_BOOT_SCR=$QSPI_OFFSET_BOOT_SCR \
# 		-D QSPI_OFFSET_BISTREAM=$QSPI_OFFSET_BISTREAM \
# 		-D QSPI_OFFSET_IMAGE=$QSPI_OFFSET_IMAGE \
# 		-x assembler-with-cpp \
# 		-I $BR2_EXTERNAL_CUSTOM_PACKAGE_PATH/board/$BR2_TARGET_GENERIC_HOSTNAME/hw-spec/device-tree \
# 		$BR2_EXTERNAL_CUSTOM_PACKAGE_PATH/board/$BR2_TARGET_GENERIC_HOSTNAME/hw-spec/user-top.dts \
# 		-o $BR2_EXTERNAL_CUSTOM_PACKAGE_PATH/board/$BR2_TARGET_GENERIC_HOSTNAME/hw-spec/devicetree.dts

# $BR2_EXTERNAL_CUSTOM_PACKAGE_PATH/output/host/bin/dtc -I dts -O dtb \
# 		-o $BR2_EXTERNAL_CUSTOM_PACKAGE_PATH/output/images/devicetree.dtb \
#         $BR2_EXTERNAL_CUSTOM_PACKAGE_PATH/board/$BR2_TARGET_GENERIC_HOSTNAME/hw-spec/devicetree.dts
# -------------------------------------------------------------------------------------------------------------------
exit $?