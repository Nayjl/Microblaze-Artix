#!/bin/sh

set -e
TOP_DIR=`dirname $0`"/"

# -------------------------------------------------------------------------------------------------------------------
cp -f ${TOP_DIR}/fit_images/image.its $1
# cp -f ${TOP_DIR}/fit_images/kernel.its $1
# cp -f ${TOP_DIR}/fit_images/rootfs.its $1
cp -f ${TOP_DIR}/boot.cmd.in $1
cp -f ${TOP_DIR}/boot-config.h $1
cp -f ${TOP_DIR}/genimage.cfg $1
cd $1

$BR2_EXTERNAL_CUSTOM_PACKAGE_PATH/output/host/bin/mkimage -f image.its image.ub
rm -f image.its
# $BR2_EXTERNAL_CUSTOM_PACKAGE_PATH/output/host/bin/mkimage -f kernel.its kernel.ub
# rm -f kernel.its
# $BR2_EXTERNAL_CUSTOM_PACKAGE_PATH/output/host/bin/mkimage -f rootfs.its rootfs.ub
# rm -f rootfs.its

cpp -P -C -nostdinc -I. -D QSPI_OFFSET_BISTREAM=$QSPI_OFFSET_BISTREAM -D QSPI_OFFSET_IMAGE=$QSPI_OFFSET_IMAGE boot.cmd.in boot.cmd
$BR2_EXTERNAL_CUSTOM_PACKAGE_PATH/output/host/bin/mkimage -A arm -T script -C none -d boot.cmd boot.scr
rm -f boot.cmd boot.cmd.in boot-config.h

$BR2_EXTERNAL_CUSTOM_PACKAGE_PATH/output/host/bin/mkimage -A arm -O linux -T kernel -C none -a 0x8000 -e 0x8000 -n "Linux Kernel" -d zImage uImage
cp rootfs.cpio.uboot uramdisk.image
# $BR2_EXTERNAL_CUSTOM_PACKAGE_PATH/output/host/bin/mkimage -A arm -O linux -T ramdisk -C lzma -n "Root Filesystem" -d rootfs.cpio.lzma uramdisk.image
# -------------------------------------------------------------------------------------------------------------------

# -------------------------------------------------------------------------------------------------------------------
cat << EOF > qspi.bif
//arch = zynq; split = false; format = BIN
the_ROM_image:
{
	[bootloader] fsbl.elf
	u-boot.elf
	[offset = ${QSPI_OFFSET_BOOT_SCR}] boot.scr
	[offset = ${QSPI_OFFSET_BISTREAM}] firmware_fpga.bit.lzma
	[offset = ${QSPI_OFFSET_IMAGE}] image.ub
}
EOF
$BR2_EXTERNAL_CUSTOM_PACKAGE_PATH/output/host/bin/bootgen -image qspi.bif -arch zynq -o QSPI.bin -w
rm -f qspi.bif

cat << EOF > fsbl.bif
//arch = zynq; split = false; format = BIN
the_ROM_image:
{
	[bootloader] fsbl.elf
	u-boot.elf
}
EOF
$BR2_EXTERNAL_CUSTOM_PACKAGE_PATH/output/host/bin/bootgen -image fsbl.bif -arch zynq -o BOOT.bin -w
rm -f fsbl.bif

# -------------------------------------------------------------------------------------------------------------------
GENIMAGE_TMP="genimage.tmp"
trap 'rm -rf "${ROOTPATH_TMP}"' EXIT
ROOTPATH_TMP="$(mktemp -d)"
rm -rf "${GENIMAGE_TMP}"
$BR2_EXTERNAL_CUSTOM_PACKAGE_PATH/output/host/bin/genimage \
--rootpath "${ROOTPATH_TMP}" \
--inputpath $1 \
--outputpath $1 \
--tmppath "${GENIMAGE_TMP}" \
--config genimage.cfg
rm -rf "${GENIMAGE_TMP}"
rm -rf genimage.cfg
# -------------------------------------------------------------------------------------------------------------------
exit $?
# -------------------------------------------------------------------------------------------------------------------
# UBOOT_ENTRY=`../host/bin/arm-linux-readelf -h u-boot.elf | sed -r '/^  Entry point address:\s*(.*)/!d; s//\1/'`
# echo Entry point address: $UBOOT_ENTRY
# cat << EOF > uboot.its
# /dts-v1/;
# / {
#     description = "U-Boot";
#     #address-cells = <1>;
#     images {
# 	uboot {
# 	    description = "U-Boot";
# 	    data = /incbin/("u-boot.bin");
# 	    type = "standalone";
# 	    arch = "arm";
# 	    os = "U-Boot";
# 	    compression = "none";
# 	    load = <${UBOOT_ENTRY}>;
# 	    entry = <${UBOOT_ENTRY}>;
# 	    hash {
# 		algo = "crc32";
# 	    };
# 	};
#     };
#     configurations {
# 	default = "conf";
# 	conf {
# 	    description = "U-Boot";
# 	    loadables = "uboot";
# 	};
#     };
# };
# EOF
# $BR2_EXTERNAL_CUSTOM_PACKAGE_PATH/output/host/bin/mkimage -f uboot.its u-boot.ub
# rm -f uboot.its
# -------------------------------------------------------------------------------------------------------------------
# LOAD_ADDR_FPGA=0x3000000
# cat << EOF > fpga.its
# /dts-v1/;
# / {
#     description = "FPGA images FIT";
#     #address-cells = <1>;
#     images {
# 	fpga-lzma-bin {
# 	    description = "FPGA images topmodule binar";
# 	    data = /incbin/("firmware_fpga.bin.lzma");
# 	    type = "fpga";
# 	    arch = "arm";
# 	    compression = "lzma";
# 	    hash {
# 	    	algo = "sha1";
# 	    };
# 	};
# 	fpga-lzma-bit {
# 	    description = "FPGA images topmodule binnic";
# 	    data = /incbin/("firmware_fpga.bit.lzma");
# 	    type = "fpga";
# 	    arch = "arm";
# 	    compression = "lzma";
# 	    hash {
# 	    	algo = "sha1";
# 	    };
# 	};
# 	fpga-bin {
# 	    description = "FPGA images topmodule binnic";
# 	    data = /incbin/("firmware_fpga.bit.bin");
# 	    type = "fpga";
# 	    arch = "arm";
# 	    compression = "none";
# 	    hash {
# 	    	algo = "sha1";
# 	    };
# 	};
# 	fpga-bit {
# 	    description = "FPGA images topmodule binnic";
# 	    data = /incbin/("firmware_fpga.bit");
# 	    type = "fpga";
# 	    arch = "arm";
# 	    compression = "none";
# 	    hash {
# 	    	algo = "sha1";
# 	    };
# 	};
#     };
#     configurations {
# 	default = "conf-lzma-bin";
# 	conf-lzma-bin {
# 	    description = "Work FPGA binarias";
# 	    fpga = "fpga-lzma-bin";
# 	};
# 	conf-lzma-bit {
# 	    description = "Work FPGA bitnic";
# 	    fpga = "fpga-lzma-bit";
# 	};
# 	conf-bin {
# 	    description = "Work FPGA bitni";
# 	    fpga = "fpga-bin";
# 	};
# 	conf-bit {
# 	    description = "Work FPGA bitn";
# 	    fpga = "fpga-bit";
# 	};
#     };
# };
# EOF
# $BR2_EXTERNAL_CUSTOM_PACKAGE_PATH/output/host/bin/mkimage -f fpga.its fpga.ub
# rm -f fpga.its
# -------------------------------------------------------------------------------------------------------------------

# $BR2_EXTERNAL_CUSTOM_PACKAGE_PATH/output/host/bin/mkimage -A arm -T firmware -C lzma -O u-boot -n "Images create mkimage" -d firmware_fpga.bit.lzma firmware_fpga.img

# rm -f firmware_fpga.bit
# rm -f firmware_fpga.bit.bin
# -------------------------------------------------------------------------------------------------------------------

