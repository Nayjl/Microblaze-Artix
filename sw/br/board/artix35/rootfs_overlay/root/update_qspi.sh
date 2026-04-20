#!/bin/sh

flash_erase /dev/mtd0 0 0
dd if=/mnt/boot/QSPI.bin of=/dev/mtd0 bs=4k
dd if=/dev/mtd0 of=/root/addr_flash.bin bs=1 count=1
