REPO_SRC ?= /home/naydan/work/repo_xilinx

PROJECT_DIR ?= $(shell pwd)
CROSS_COMPILE ?= arm-linux-gnueabihf-
ARCH ?= arm

PATH_DEVICE_TREE ?= device_tree_bsp_0
DEVICE_TREE ?= devicetree
DEVICE_TREE_STRING ?= $(DEVICE_TREE).dts
DEVICE_TREE_BLOB ?= $(DEVICE_TREE).dtb
DEVICE_TREE_TOP ?= system-top.dts


PATH_UBOOT := u-boot-xlnx
UBOOT ?= u-boot.elf
PATH_OUTPUT_UBOOT_FILES := $(REPO_SRC)/$(PATH_UBOOT)
DEFCONFIG_UBOOT ?= xilinx_zynq_virt_defconfig

PATH_KERNEL := linux-xlnx
KERNEL ?= uImage
PATH_OUTPUT_KERNEL_FILE := $(REPO_SRC)/$(PATH_KERNEL)/arch/arm/boot
DEFCONFIG_KERNEL ?= xilinx_zynq_defconfig


PATH_SRC_ROOTFS ?= rootfs
OBRAZ_ROOTFS ?= .image
TYPE_COMPRESS ?= .gz
NAME_SRC_ROOTFS_COMPRESS ?= arm_ramdisk
NEW_NAME_ROOTFS_COMPRESS ?= uramdisk.image.gz
UNCOMPRESS_ROOTFS ?= gunzip
COMPRESS_ROOTFS ?= gzip

PATH_BOOTCMD ?= .
NAME_BOOTCMD ?= boot.cmd
OUTPUT_NAME_BOOTSCR ?= boot.scr

#--------------------------------------------------------------Device Tree------------------------------------------------------------------------
dt_all: dt_compil dtb_build

dt_compil: $(PROJECT_DIR)/$(PATH_DEVICE_TREE)/$(DEVICE_TREE_TOP)
	@echo "Device Tree: Компановка всех *.dts"
	gcc -E -nostdinc \
	-undef -D__DTS__ \
	-x assembler-with-cpp \
	-I $(PROJECT_DIR)/$(PATH_DEVICE_TREE) \
	$(PROJECT_DIR)/user_top.dts \
	-o $(PROJECT_DIR)/$(DEVICE_TREE_STRING)

dtb_build: $(PROJECT_DIR)/$(DEVICE_TREE_STRING)
	@echo "Device Tree: Сборка $(PROJECT_DIR)/$(DEVICE_TREE_BLOB) из $(PROJECT_DIR)/$(DEVICE_TREE_STRING)"
	dtc -I dts -O dtb -o $(PROJECT_DIR)/$(DEVICE_TREE_BLOB) $(PROJECT_DIR)/$(DEVICE_TREE_STRING)

dts_build: $(PROJECT_DIR)/$(DEVICE_TREE_BLOB)
	@echo "Device Tree: Пересборка сборка $(PROJECT_DIR)/$(DEVICE_TREE_STRING) из $(PROJECT_DIR)/$(DEVICE_TREE_BLOB)"
	dtc -I dtb -O dts -o $(PROJECT_DIR)/$(DEVICE_TREE_STRING) $(PROJECT_DIR)/$(DEVICE_TREE_BLOB)
#--------------------------------------------------------------Device Tree------------------------------------------------------------------------

#------------------------------------------------------------------U-BOOT--------------------------------------------------------------------------
uboot_all: uboot_distclean uboot_setdefconfig uboot_build uboot_cpUboot

uboot_distclean: uboot_clean
	@echo "Uboot: Полная очистка uboot"
	$(MAKE) -C $(REPO_SRC)/$(PATH_UBOOT) distclean

uboot_clean: 
	@echo "Uboot: Очистка uboot"
	$(MAKE) -C $(REPO_SRC)/$(PATH_UBOOT) clean

uboot_setdefconfig:
	@echo "Uboot: Установка конфига uboot"
	$(MAKE) -C $(REPO_SRC)/$(PATH_UBOOT) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) DEVICE_TREE=$(DEVICE_TREE) $(DEFCONFIG_UBOOT)

uboot_build: 
	@echo "Uboot: Сборка uboot"
	$(MAKE) -C $(REPO_SRC)/$(PATH_UBOOT) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) DEVICE_TREE=$(DEVICE_TREE) -j$(shell nproc)

uboot_cpUboot: $(PATH_OUTPUT_UBOOT_FILES)/$(UBOOT)
	cp -f $(PATH_OUTPUT_UBOOT_FILES)/$(UBOOT) $(PWD)/$(UBOOT)
	@echo "Uboot: Файл $(UBOOT) скопирован в папку проекта"

uboot_cpDeviceTree: $(PROJECT_DIR)/$(DEVICE_TREE_BLOB)
	@echo "Uboot: Копирование dtb в каталог uboot"
	cp -f $(PROJECT_DIR)/$(DEVICE_TREE_BLOB) $(REPO_SRC)/$(PATH_UBOOT)/arch/arm/dts/$(DEVICE_TREE_BLOB)

uboot_nconfig: 
	@echo "Uboot: Открытие графического редактора uboot"
	$(MAKE) -C $(REPO_SRC)/$(PATH_UBOOT) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) nconfig
#------------------------------------------------------------------U-BOOT--------------------------------------------------------------------------

#------------------------------------------------------Kernel----------------------------------------------------
kernel_all: kernel_distclean kernel_setdefconfig kernel_build kernel_cpImage

kernel_distclean: kernel_clean
	@echo "Kernel: Полная очистка ядра"
	$(MAKE) -C $(REPO_SRC)/$(PATH_KERNEL) distclean

kernel_clean: 
	@echo "Kernel: Очистка ядра"
	$(MAKE) -C $(REPO_SRC)/$(PATH_KERNEL) clean

kernel_setdefconfig:
	@echo "Kernel: Установка конфига ядра"
	$(MAKE) -C $(REPO_SRC)/$(PATH_KERNEL) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) $(DEFCONFIG_KERNEL)

kernel_build: 
	@echo "Kernel: Сборка ядра"
	$(MAKE) -C $(REPO_SRC)/$(PATH_KERNEL) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) UIMAGE_LOADADDR=0x8000 uImage -j$(shell nproc)

kernel_cpImage: $(PATH_OUTPUT_KERNEL_FILE)/$(KERNEL)
	cp -f $(PATH_OUTPUT_KERNEL_FILE)/$(KERNEL) $(PROJECT_DIR)/$(KERNEL)
	@echo "Kernel: Файл $(PATH_OUTPUT_KERNEL_FILE)/$(KERNEL) скопирован в папку проекта $(PROJECT_DIR)/$(KERNEL)"

kernel_nconfig: 
	@echo "Kernel: Открытие графического редактора ядра"
	$(MAKE) -C $(REPO_SRC)/$(PATH_KERNEL) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) nconfig
#------------------------------------------------------Kernel--------------------------------------------------------------------------


#---------------------------------------------------------ROOTFS------------------------------------------------------------------------

rootfs_all: rootfs_uncompress rootfs_access_chmod rootfs_mount

rootfs_uncompress: $(PROJECT_DIR)/$(PATH_SRC_ROOTFS)/$(NAME_SRC_ROOTFS_COMPRESS)$(OBRAZ_ROOTFS)$(TYPE_COMPRESS)
	@echo "ROOTFS: Распаковка архива образа файловой системы $(PROJECT_DIR)/$(PATH_SRC_ROOTFS)/$(NAME_SRC_ROOTFS_COMPRESS)$(OBRAZ_ROOTFS)$(TYPE_COMPRESS)"
	$(UNCOMPRESS_ROOTFS) $(PROJECT_DIR)/$(PATH_SRC_ROOTFS)/$(NAME_SRC_ROOTFS_COMPRESS)$(OBRAZ_ROOTFS)$(TYPE_COMPRESS)
	
rootfs_access_chmod: 
	@echo "ROOTFS: Изменение прав доступа"
	chmod u+rwx $(PROJECT_DIR)/$(PATH_SRC_ROOTFS)/$(NAME_SRC_ROOTFS_COMPRESS)$(OBRAZ_ROOTFS)$(TYPE_COMPRESS)

rootfs_mount: rootfs_dirtmp
	@echo "ROOTFS: Монтирование файловой системы в папку $(PROJECT_DIR)/$(PATH_SRC_ROOTFS)/tmp_mnt_rootfs/"
	sudo mount -o loop $(PROJECT_DIR)/$(PATH_SRC_ROOTFS)/$(NAME_SRC_ROOTFS_COMPRESS)$(OBRAZ_ROOTFS) $(PROJECT_DIR)/$(PATH_SRC_ROOTFS)/tmp_mnt_rootfs/

rootfs_umount: 
	@echo "ROOTFS: Размонтирование файловой системы в папке $(PROJECT_DIR)/$(PATH_SRC_ROOTFS)/tmp_mnt_rootfs/"
	sudo umount $(PROJECT_DIR)/$(PATH_SRC_ROOTFS)/tmp_mnt_rootfs/

rootfs_mkimage: 
	@echo "ROOTFS: заголовком U-Boot $(PROJECT_DIR)/$(PATH_SRC_ROOTFS)/$(NAME_SRC_ROOTFS_COMPRESS)$(OBRAZ_ROOTFS)$(TYPE_COMPRESS) \
	и новая файловая система  $(PROJECT_DIR)/$(PATH_SRC_ROOTFS)/$(NEW_NAME_ROOTFS_COMPRESS)$(OBRAZ_ROOTFS)$(TYPE_COMPRESS)"
	mkimage -A arm -T ramdisk -C $(COMPRESS_ROOTFS) -d $(PROJECT_DIR)/$(PATH_SRC_ROOTFS)/$(NAME_SRC_ROOTFS_COMPRESS)$(OBRAZ_ROOTFS)$(TYPE_COMPRESS) \
	$(PROJECT_DIR)/$(PATH_SRC_ROOTFS)/$(NEW_NAME_ROOTFS_COMPRESS)$(OBRAZ_ROOTFS)$(TYPE_COMPRESS)

rootfs_dirtmp: 
	@echo "ROOTFS: Создание папки для монтирования файловой системы $(PROJECT_DIR)/$(PATH_SRC_ROOTFS)/tmp_mnt_rootfs/"
	mkdir -p $(PROJECT_DIR)/$(PATH_SRC_ROOTFS)/tmp_mnt_rootfs/

#---------------------------------------------------------ROOTFS------------------------------------------------------------------------


#---------------------------------------------------------BOOT_SCR----------------------------------------------------------------------
bootscr_crt: $(PATH_BOOTCMD)/$(NAME_BOOTCMD)
	mkimage -A $(ARCH) -T script -C none -n "Boot script" -d $(PATH_BOOTCMD)/$(NAME_BOOTCMD) $(PATH_BOOTCMD)/$(OUTPUT_NAME_BOOTSCR)
	
#---------------------------------------------------------BOOT_SCR----------------------------------------------------------------------
