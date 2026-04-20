CMA_DMA_PL_VERSION = 0.0.1
CMA_DMA_PL_SITE = $(BR2_EXTERNAL_CUSTOM_PACKAGE_PATH)/dl/cma_dma_pl
CMA_DMA_PL_SITE_METHOD = local
CMA_DMA_PL_LICENSE = GPL-2.0+
CMA_DMA_PL_LICENSE_FILES = COPYING

# CMA_DMA_PL_MODULE_NAME = cma_dma_pl.ko
# CMA_DMA_PL_MODULE_SUBDIR = .
# CMA_DMA_PL_MAKE_OPTS = \
#     TARGET=cma_dma_pl \
#     KDIR=$(LINUX_DIR) \
#     ARCH=$(BR2_ARCH) \
#     CROSS_COMPILE=$(TARGET_CROSS)





# # Если встраиваем в ядро
# ifeq ($(BR2_PACKAGE_CMA_DMA_PL_BUILTIN),y)
# # Копируем исходники в дерево ядра
# define CMA_DMA_PL_PREPARE_KERNEL
#     mkdir -p $(LINUX_DIR)/drivers/char/cma_dma_pl
#     cp -f $(@D)/cma_dma_pl.c $(LINUX_DIR)/drivers/char/cma_dma_pl/
#     cp -f $(@D)/Makefile.kernel $(LINUX_DIR)/drivers/char/cma_dma_pl/Makefile
#     echo "obj-y += cma_dma_pl/" >> $(LINUX_DIR)/drivers/char/Makefile
# endef
# # Патчим конфигурацию ядра
# define CMA_DMA_PL_CONFIGURE_KERNEL
#     echo "CONFIG_CMA_DMA_PL=y" >> $(LINUX_DIR)/.config
#     $(MAKE) -C $(LINUX_DIR) olddefconfig
# endef
# CMA_DMA_PL_PRE_CONFIGURE_HOOKS += CMA_DMA_PL_PREPARE_KERNEL
# CMA_DMA_PL_POST_CONFIGURE_HOOKS += CMA_DMA_PL_CONFIGURE_KERNEL
# endif

CMA_DMA_PL_MODULE_NAME = cma_dma_pl.ko
CMA_DMA_PL_DEPENDENCIES = linux
CMA_DMA_PL_MODULE_SUBDIR = .
CMA_DMA_PL_MAKE_OPTS = \
    KDIR=$(LINUX_DIR) \
    ARCH=$(BR2_ARCH) \
    CROSS_COMPILE=$(TARGET_CROSS)

define CMA_DMA_PL_CLEAN_CMDS
    $(MAKE) -C $(@D) clean \
        KDIR=$(LINUX_DIR) \
        ARCH=$(KERNEL_ARCH) \
        CROSS_COMPILE=$(TARGET_CROSS) \
        TARGET=cma_dma_pl
endef

define CMA_DMA_PL_INSTALL_INIT_SYSV
    $(INSTALL) -D -m 0644 $(CMA_DMA_PL_PKGDIR)/cma_dma_pl.modules $(TARGET_DIR)/etc/modules
endef

# define CMA_DMA_PL_INSTALL_TARGET_CMDS
#     $(INSTALL) -D -m 0644 $(@D)/cma_dma_pl.ko \
#         $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/extra/cma_dma_pl.ko
#     depmod -a -b $(TARGET_DIR) $(LINUX_VERSION_PROBED)
# endef


$(eval $(kernel-module))
$(eval $(generic-package))
