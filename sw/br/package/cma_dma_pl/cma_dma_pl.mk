CMA_DMA_PL_VERSION = $(subst ",,$(BR2_PACKAGE_VER_CMA_DMA_PL))
CMA_DMA_PL_SITE = $(call github,Nayjl,cma_dma_pl,$(CMA_DMA_PL_VERSION))

CMA_DMA_PL_MODULE_NAME = cma_dma_pl.ko
CMA_DMA_PL_DEPENDENCIES = linux
CMA_DMA_PL_MODULE_SUBDIR = .
CMA_DMA_PL_MAKE_OPTS = \
    KDIR=$(LINUX_DIR) \
    ARCH=$(BR2_ARCH) \
    CROSS_COMPILE=$(TARGET_CROSS)

define CMA_DMA_PL_CLEAN_CMDS
    @rm -fv $(@D)/*.symvers $(@D)/Module.symvers $(@D)/Module.markers $(@D)/modules.order
 	@rm -rfv $(@D)/.tmp_versions
 	@rm -fv $(@D)/*.ko $(@D)/*.mod* $(@D)/*.o $(@D)/.*.cmd
endef

ifeq ($(BR2_PACKAGE_DEAMON_CMA_DMA_PL),y)
define CMA_DMA_PL_INSTALL_INIT_SYSV
    @echo "Automatic run module driver kernel -----> $(TARGET_DIR)/etc/"
    $(INSTALL) -D -m 0644 $(CMA_DMA_PL_PKGDIR)/S70cma_dma_pl $(TARGET_DIR)/etc/init.d
    chmod +x $(TARGET_DIR)/etc/init.d/S70cma_dma_pl
endef
endif

# define CMA_DMA_PL_INSTALL_TARGET_CMDS
#     $(INSTALL) -D -m 0644 $(@D)/cma_dma_pl.ko \
#         $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/extra/cma_dma_pl.ko
#     depmod -a -b $(TARGET_DIR) $(LINUX_VERSION_PROBED)
# endef

$(eval $(kernel-module))
$(eval $(generic-package))
