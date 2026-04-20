XVC_SERVER_VERSION = 0.0.1
XVC_SERVER_SITE = $(BR2_EXTERNAL_CUSTOM_PACKAGE_PATH)/dl/xvc-server
XVC_SERVER_SITE_METHOD = local
# XVC_SERVER_LICENSE = All Rights Reserved
# XVC_SERVER_LICENSE_FILES =

define XVC_SERVER_BUILD_CMDS
	$(MAKE) -C $(@D) all
endef

define XVC_SERVER_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/xvc-server-$(XVC_SERVER_VERSION) $(TARGET_DIR)/usr/bin/xvc
endef

$(eval $(generic-package))
