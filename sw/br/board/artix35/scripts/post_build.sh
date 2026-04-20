#!/bin/sh

set -e

TOP_DIR_POST_BUILD=$BR2_EXTERNAL_CUSTOM_PACKAGE_PATH


cd $TOP_DIR_POST_BUILD/output/images

cp -f $HARDWARE_SPECIFICATION_HW_PATH/*.bit ./firmware_fpga.bit
cp -f $HARDWARE_SPECIFICATION_HW_PATH/ps7_init.tcl ./ps7_init.tcl
$BR2_EXTERNAL_CUSTOM_PACKAGE_PATH/output/host/bin/lzma -v -c -z firmware_fpga.bit > firmware_fpga.bit.lzma


cp -f $HARDWARE_SPECIFICATION_FSBL_PATH/Debug/*.elf \
$BR2_EXTERNAL_CUSTOM_PACKAGE_PATH/output/images/fsbl.elf


mkdir -p $BR2_EXTERNAL_CUSTOM_PACKAGE_PATH/board/$NAME_BOARD/rootfs_overlay/etc/dropbear
rm -f $BR2_EXTERNAL_CUSTOM_PACKAGE_PATH/board/$NAME_BOARD/rootfs_overlay/etc/dropbear/dropbear_ed25519_host_key
dropbearkey -t ed25519 -f $BR2_EXTERNAL_CUSTOM_PACKAGE_PATH/board/$NAME_BOARD/rootfs_overlay/etc/dropbear/dropbear_ed25519_host_key
