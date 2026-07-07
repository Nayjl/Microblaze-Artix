#!/bin/bash

set -e
TOP_DIR="$(dirname "$0")"
BINARIES_DIR="${BINARIES_DIR:-output/images}"
HOST_DIR="${HOST_DIR:-output/host}"
TARGET_DIR="${TARGET_DIR:-output/target}"
BOARD_DIR="${BOARD_DIR:-board/default}"

pwd
echo ">>>>>>>>>>>>>${TOP_DIR}<<<<<<<<<<<<<"
# -------------------------------------------------------------------------------------------------------------------
cp -f ${TOP_DIR}/hw-spec/*.bit ${BINARIES_DIR}/firmware_fpga.bit
lzma -v -c -z ${BINARIES_DIR}/firmware_fpga.bit > ${BINARIES_DIR}/firmware_fpga.bit.lzma
# -------------------------------------------------------------------------------------------------------------------
# cp -f ${TOP_DIR}/hw-spec/*init.tcl ${BINARIES_DIR}/ps_init.tcl
# -------------------------------------------------------------------------------------------------------------------
# cp -f ${TOP_DIR}/hw-spec/fsbl/executable.elf ${BINARIES_DIR}/fsbl.elf
# -------------------------------------------------------------------------------------------------------------------
# mkdir -p ${TOP_DIR}/rootfs-overlay/etc/dropbear
# rm -f ${TOP_DIR}/rootfs-overlay/etc/dropbear/dropbear_ed25519_host_key
# dropbearkey -t ed25519 -f ${TOP_DIR}/rootfs-overlay/etc/dropbear/dropbear_ed25519_host_key
# -------------------------------------------------------------------------------------------------------------------
# gcc -E -nostdinc \
# 		-undef -D__DTS__ \
# 		-D QSPI_OFFSET_BOOT_SCR=$QSPI_OFFSET_BOOT_SCR \
# 		-D QSPI_OFFSET_BISTREAM=$QSPI_OFFSET_BISTREAM \
# 		-D QSPI_OFFSET_IMAGE=$QSPI_OFFSET_IMAGE \
# 		-x assembler-with-cpp \
# 		-I $TOP_DIR/hw-spec/device-tree \
# 		$TOP_DIR/hw-spec/user-top.dts \
# 		-o $TOP_DIR/hw-spec/devicetree.dts

dtc -I dts -O dtb \
		-o ${BINARIES_DIR}/devicetree.dtb \
        ${TOP_DIR}/hw-spec/devicetree.dts
# -------------------------------------------------------------------------------------------------------------------
exit $?