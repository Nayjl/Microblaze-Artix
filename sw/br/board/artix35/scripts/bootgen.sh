#!/bin/sh

set -e
TOP_DIR=`dirname $0`"/"

cd $1

# -------------------------------------------------------------------------------------------------------------------
# QSPI_OFFSET_SPL_UBOOT=0x100000
# QSPI_OFFSET_SPL_BOOT_SCR=0x200000
# QSPI_OFFSET_SPL_BISTREAM=0x202000
# QSPI_OFFSET_SPL_IMAGE=0x302000
# cat << EOF > spl_image.bif
# //arch = zynq; split = false; format = BIN
# the_ROM_image:
# {
# 	[bootloader] u-boot-spl.bin
# 	[offset = ${QSPI_OFFSET_SPL_UBOOT}] u-boot.ub
# 	[offset = ${QSPI_OFFSET_SPL_BOOT_SCR}] boot.scr
# 	[offset = ${QSPI_OFFSET_SPL_BISTREAM}] fpga.ub
# 	[offset = ${QSPI_OFFSET_SPL_IMAGE}] image.ub
# }
# EOF
# $BR2_EXTERNAL_CUSTOM_PACKAGE_PATH/output/host/bin/bootgen -image spl_image.bif -arch zynq -o SPL_IMAGE.bin -w
# rm -f spl_image.bif

# cat << EOF > spl_boot.bif
# //arch = zynq; split = false; format = BIN
# the_ROM_image:
# {
# 	[bootloader] u-boot-spl.bin
# 	[offset = ${QSPI_OFFSET_SPL_UBOOT}] u-boot.ub
# }
# EOF
# $BR2_EXTERNAL_CUSTOM_PACKAGE_PATH/output/host/bin/bootgen -image spl_boot.bif -arch zynq -o SPL_BOOT.bin -w
# rm -f spl_boot.bif

# -------------------------------------------------------------------------------------------------------------------
QSPI_OFFSET_BOOT_SCR=0x11D000
QSPI_OFFSET_BISTREAM=0x11F000
QSPI_OFFSET_IMAGE=0x21F000
cat << EOF > fsbl.bif
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
$BR2_EXTERNAL_CUSTOM_PACKAGE_PATH/output/host/bin/bootgen -image fsbl.bif -arch zynq -o BOOT.bin -w
rm -f fsbl.bif

# -------------------------------------------------------------------------------------------------------------------

rm -rf $1/genimage.tmp
mkdir -p $1/genimage.tmp

cat << EOF > genimage.cfg
image boot.vfat {
    vfat {
    	label = "boot"
        files = {
            	"BOOT.bin",
		"boot.scr",
            	"uImage",
		"kernel.ub",
            	"devicetree.dtb",
		"uramdisk.image.lzma",
		"rootfs.ub",
		"image.ub",
            	"firmware_fpga.bit"
        }
    }
    size = 512M
}
image rootfs.ext4 {
    ext4 {
        label = "rootfs"
	
    }
    size = 8192M
}
image data.ext4 {
    ext4 {
        label = "data"
    }
    size = 4096M
}
image sdcard.img {
    hdimage {
        partition-table-type = "mbr" 
    }
    partition boot {
        partition-type = 0xC
        bootable = "true"
        image = "boot.vfat"
    }
    partition rootfs {
        partition-type = 0x83
        image = "rootfs.ext4"
    }
    partition data {
        partition-type = 0x83
        image = "data.ext4"
    }
}
EOF

$BR2_EXTERNAL_CUSTOM_PACKAGE_PATH/output/host/bin/genimage \
--rootpath $BR2_EXTERNAL_CUSTOM_PACKAGE_PATH/output/target \
--tmppath $1/genimage.tmp \
--inputpath $1 \
--outputpath $1 \
--config $1/genimage.cfg
rm -rf $1/genimage.tmp
rm -rf genimage.cfg
