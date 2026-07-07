################################################################################
#
# zynq-mkbootimage
#
################################################################################

ZYNQ_MKBOOTIMAGE_VERSION = 29f7d69d115c20dc1b3a63810ebcb2451a7a1411
ZYNQ_MKBOOTIMAGE_SITE = https://github.com/antmicro/zynq-mkbootimage.git
ZYNQ_MKBOOTIMAGE_SITE_METHOD = git
ZYNQ_MKBOOTIMAGE_DEPENDENCIES = host-elfutils

define HOST_ZYNQ_MKBOOTIMAGE_BUILD_CMDS
    $(HOST_MAKE_ENV) $(HOST_CONFIGURE_OPTS) $(MAKE) -C $(@D) all
endef

define HOST_ZYNQ_MKBOOTIMAGE_INSTALL_CMDS
    $(INSTALL) -D -m 0755 $(@D)/mkbootimage $(HOST_DIR)/bin; \
    $(INSTALL) -D -m 0755 $(@D)/exbootimage $(HOST_DIR)/bin;
endef

$(eval $(host-generic-package))
