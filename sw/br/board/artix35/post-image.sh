#!/bin/bash

set -e
TOP_DIR="$(dirname "$0")"
BINARIES_DIR="${BINARIES_DIR:-output/images}"
HOST_DIR="${HOST_DIR:-output/host}"
TARGET_DIR="${TARGET_DIR:-output/target}"
BOARD_DIR="${BOARD_DIR:-board/default}"
OUT_IMAGES_DIR=$1

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m' # No Color (сброс)

pwd
echo ">>>>>>>>>>>>>${TOP_DIR}<<<<<<<<<<<<<"
echo ">>>>>>>>>>>>>${OUT_IMAGES_DIR}<<<<<<<<<<<<<"
cd ${OUT_IMAGES_DIR}
# -------------------------------------------------------------------------------------------------------------------
# cp -f ${TOP_DIR}/image.its image.its
# mkimage -f image.its image.ub
# rm -f image.its
# mkimage -A arm -O linux -T kernel -C none -a 0x8000 -e 0x8000 -n "Linux Kernel" -d zImage uImage
# -------------------------------------------------------------------------------------------------------------------
# UBOOT_ENTRY=`arm-linux-readelf -h u-boot | sed -r '/^  Entry point address:\s*(.*)/!d; s//\1/'`
# -------------------------------------------------------------------------------------------------------------------
# QSPI_OFFSET_BOOT_SCR=0x100000
# QSPI_OFFSET_BISTREAM=0x104000
# QSPI_OFFSET_IMAGE=0x284000
# # mmc dev 0 && fatload mmc 0 0x2000000 boot.scr && source 0x2000000; mmc dev 1 && fatload mmc 1 0x2000000 boot.scr && source 0x2000000; sf probe 0 0 0 && sf read 0x2000000 0x100000 0x40000 && source 0x2000000
# ADDRM_DTB=0x2040000
# ADDRM_KRNL=0x204F000
# ADDRM_RTFS=0x3000000
# ADDRFLASH_FPGA=$QSPI_OFFSET_BISTREAM
# SIZEFLASH_FPGA=$(($QSPI_OFFSET_IMAGE - $QSPI_OFFSET_BISTREAM))
# ADDRFLASH_IMAGE=$QSPI_OFFSET_IMAGE
# SIZEFLASH_IMAGE=0x1000000
# cat << EOF > boot.cmd
# setenv bootargs_min earlycon console=ttyPS0,115200 uio_pdrv_genirq.of_id=generic-uio
# setenv bootmode_mmc0 'fatload mmc 0:1 $ADDRM_KRNL uImage && fatload mmc 0:1 $ADDRM_DTB devicetree.dtb'
# setenv bootmode_mmc1 'fatload mmc 1:1 $ADDRM_KRNL uImage && fatload mmc 1:1 $ADDRM_DTB devicetree.dtb'
# setenv program_fpga_mmc 'fpga loadb 0 $ADDRM_DTB \${filesize}'
# setenv bootargs \${bootargs_min} root=/dev/ram0 rw rootfstype=cpio rootwait cma=128M
# mmc dev 0
# if test $? -eq 0; then
#     if test -e mmc 0:1 /firmware_fpga.bit; then
#         fatload mmc 0:1 $ADDRM_DTB firmware_fpga.bit
#         run program_fpga_mmc
#     fi
#     if test -e mmc 0:1 /uImage && test -e mmc 0:1 /devicetree.dtb; then
#         run bootmode_mmc0
#         if test $? -eq 0 && test -e mmc 0:2 /bin/sh; then
#             setenv bootargs \${bootargs_min} root=/dev/mmcblk0p2 rw rootfstype=ext4 rootwait cma=128M
#             bootm $ADDRM_KRNL - $ADDRM_DTB
#         fi
#     fi
#     if test -e mmc 0:1 /rootfs.cpio.uboot; then
#         setenv bootmode_mmc_run \${bootmode_mmc0}'&& fatload mmc 0:1 $ADDRM_RTFS rootfs.cpio.uboot'
#         run bootmode_mmc_run
#         if test $? -eq 0; then
#             bootm $ADDRM_KRNL $ADDRM_RTFS $ADDRM_DTB
#         fi
#     elif test -e mmc 0:1 /image.ub; then
#         fatload mmc 0:1 $ADDRM_DTB image.ub
#         bootm $ADDRM_DTB
#     fi
# fi
# mmc dev 1
# if test $? -eq 0; then
#     if test -e mmc 1:1 /firmware_fpga.bit; then
#         fatload mmc 1:1 $ADDRM_DTB firmware_fpga.bit
#         run program_fpga_mmc
#     fi
#     if test -e mmc 1:1 /uImage && test -e mmc 1:1 /devicetree.dtb; then
#         run bootmode_mmc1
#         if test $? -eq 0 && test -e mmc 1:2 /bin/sh; then
#             setenv bootargs \${bootargs_min} root=/dev/mmcblk1p2 rw rootfstype=ext4 rootwait cma=128M
#             bootm $ADDRM_KRNL - $ADDRM_DTB
#         fi
#     fi
#     if test -e mmc 1:1 /rootfs.cpio.uboot; then
#         setenv bootmode_mmc_run \${bootmode_mmc1}'&& fatload mmc 1:1 $ADDRM_RTFS rootfs.cpio.uboot'
#         run bootmode_mmc_run
#         if test $? -eq 0; then
#             bootm $ADDRM_KRNL $ADDRM_RTFS $ADDRM_DTB
#         fi
#     elif test -e mmc 1:1 /image.ub; then
#         fatload mmc 1:1 $ADDRM_DTB image.ub
#         bootm $ADDRM_DTB
#     fi
# fi
# sf probe 0 0 0
# if test $? -eq 0; then
#     sf read $ADDRM_DTB $ADDRFLASH_FPGA $SIZEFLASH_FPGA
#     lzmadec $ADDRM_DTB $ADDRM_RTFS
#     fpga loadb 0 $ADDRM_RTFS \${filesize}
#     sf read $ADDRM_KRNL $ADDRFLASH_IMAGE $SIZEFLASH_IMAGE
#     if test $? -eq 0; then
#         bootm $ADDRM_KRNL
#     fi
# fi
# EOF
# mkimage -A arm -T script -C none -d boot.cmd boot.scr
# rm -f boot.cmd
# -------------------------------------------------------------------------------------------------------------------
# cp -f ${TOP_DIR}/fsbl.bif fsbl.bif
# bootgen -image fsbl.bif -arch zynq -o BOOT.bin -w
# # mkbootimage fsbl.bif BOOT.bin
# rm -f fsbl.bif

# cat << EOF > qspi-fsbl.bif
# //arch = zynq; split = false; format = BIN
# the_ROM_image:
# {
# 	[bootloader] fsbl.elf
# 	u-boot.elf
# 	[offset = ${QSPI_OFFSET_BOOT_SCR}] boot.scr
# 	[offset = ${QSPI_OFFSET_BISTREAM}] firmware_fpga.bit.lzma
# 	[offset = ${QSPI_OFFSET_IMAGE}] image.ub
# }
# EOF
# bootgen -image qspi-fsbl.bif -arch zynq -o qspi-fsbl.bin -w
# # mkbootimage qspi-fsbl.bif qspi-fsbl.bin
# rm -f ${OUT_IMAGES_DIR}/qspi-fsbl.bif
# -------------------------------------------------------------------------------------------------------------------
# GENIMAGE_TMP_SD="$(mktemp -d "${BINARIES_DIR}/genimage-sd.tmp.XXXXXX")"
# ROOTPATH_TMP_SD="$(mktemp -d "${BINARIES_DIR}/rootpath-sd.tmp.XXXXXX")"

# GENIMAGE_TMP_SD_SPL="$(mktemp -d "${BINARIES_DIR}/genimage-sd-spl.tmp.XXXXXX")"
# ROOTPATH_TMP_SD_SPL="$(mktemp -d "${BINARIES_DIR}/rootpath-sd-spl.tmp.XXXXXX")"

# GENIMAGE_TMP_QSPI_SPL="$(mktemp -d "${BINARIES_DIR}/genimage-qspi-spl.tmp.XXXXXX")"
# ROOTPATH_TMP_QSPI_SPL="$(mktemp -d "${BINARIES_DIR}/rootpath-qspi-spl.tmp.XXXXXX")"

# cleanup() {
#     rm -rf "${GENIMAGE_TMP_SD}" "${ROOTPATH_TMP_SD}" \
#            "${GENIMAGE_TMP_SD_SPL}" "${ROOTPATH_TMP_SD_SPL}" \
#            "${GENIMAGE_TMP_QSPI_SPL}" "${ROOTPATH_TMP_QSPI_SPL}"
# }
# trap cleanup EXIT
# -------------------------------------------------------------------------------------------------------------------
# genimage \
#     --rootpath "${ROOTPATH_TMP_SD}" \
#     --inputpath "${BINARIES_DIR}" \
#     --outputpath "${BINARIES_DIR}" \
#     --tmppath "${GENIMAGE_TMP_SD}" \
#     --config "${TOP_DIR}/genimage-sd.cfg"
# -------------------------------------------------------------------------------------------------------------------
# genimage \
#     --rootpath "${ROOTPATH_TMP_SD_SPL}" \
#     --inputpath "${BINARIES_DIR}" \
#     --outputpath "${BINARIES_DIR}" \
#     --tmppath "${GENIMAGE_TMP_SD_SPL}" \
#     --config "${TOP_DIR}/genimage-sd-spl.cfg"
# -------------------------------------------------------------------------------------------------------------------
# cat << EOF > genimage-qspi-spl.cfg
# flash nor-256M-64k {
# 	pebsize = 256
# 	numpebs = 131072
# 	minimum-io-unit-size = 256
# }
# image qspi.img {
# 	flash {
# 	}
# 	flashtype = "nor-256M-64k"
# 	partition qspi-boot-bin {
# 		image = "boot.bin"
# 		offset = 0x0
# 		size = 0x80000
# 	}
# 	partition qspi-u-boot-img {
# 		image = "u-boot.img"
# 		offset = 0x80000
# 		size = 0x100000
# 	}
# 	partition qspi-u-boot-script {
# 		image = "boot.scr"
# 		offset = ${QSPI_OFFSET_BOOT_SCR}
# 		size = 0x4000
# 	}
#     partition qspi-bitstream {
# 		image = "firmware_fpga.bit.lzma"
# 		offset = ${QSPI_OFFSET_BISTREAM}
# 		size = 0x100000
# 	}
# 	partition qspi-image-ub {
# 		image = "image.ub"
# 		offset = ${QSPI_OFFSET_IMAGE}
# 		size = 0x1000000
# 	}
# }
# EOF
# genimage \
#     --rootpath "${ROOTPATH_TMP_QSPI_SPL}" \
#     --inputpath "${BINARIES_DIR}" \
#     --outputpath "${BINARIES_DIR}" \
#     --tmppath "${GENIMAGE_TMP_QSPI_SPL}" \
#     --config "${OUT_IMAGES_DIR}/genimage-qspi-spl.cfg"
# rm -f genimage-qspi-spl.cfg
# -------------------------------------------------------------------------------------------------------------------
echo -e "${GREEN}<============================== All steps completed successfully ===============================>${NC}"
# exit $?
