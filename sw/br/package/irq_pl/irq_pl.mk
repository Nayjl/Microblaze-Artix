IRQ_PL_VERSION = 0.0.2
IRQ_PL_SITE = $(BR2_EXTERNAL_CUSTOM_PACKAGE_PATH)/dl/irq_pl
IRQ_PL_SITE_METHOD = local
IRQ_PL_LICENSE = GPL-2.0+
IRQ_PL_LICENSE_FILES = COPYING

define IRQ_PL_CLEAN_CMDS
    $(MAKE) -C $(@D) clean \
        KDIR=$(LINUX_DIR) \
        ARCH=$(KERNEL_ARCH) \
        CROSS_COMPILE=$(TARGET_CROSS) \
        TARGET=irq_pl
endef

# define IRQ_PL_INSTALL_INIT_SYSV
#     $(INSTALL) -D -m 0755 $(IRQ_PL_PKGDIR)/S87cma_dma_pl $(TARGET_DIR)/etc/init.d/S87cma_dma_pl
# endef

define IRQ_PL_INSTALL_TARGET_CMDS
    $(INSTALL) -D -m 0644 $(@D)/irq_pl.ko $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/extra/irq_pl.ko
    depmod -a -b $(TARGET_DIR) $(LINUX_VERSION_PROBED)
endef


$(eval $(kernel-module))
$(eval $(generic-package))
