
EMBEDDEDHW_XLNX_VERSION = $(subst ",,$(BR2_PACKAGE_XILINX_TOOLS_VERSION))
EMBEDDEDHW_XLNX_SITE_METHOD = local
EMBEDDEDHW_XLNX_SITE = $(BR2_EXTERNAL)/package/embeddedhw-xlnx

HWTOOLSXLNX = $(subst ",,$(BR2_PACKAGE_XILINX_TOOLS_INSTALLED)/Vivado/$(EMBEDDEDHW_XLNX_VERSION)/bin/vivado)

# ifeq ($(BR2_PACKAGE_EMBEDDEDHW_XLNX),y)
# XPR_PATHS := $(wildcard $(BR2_PACKAGE_EMBEDDEDHW_XLNX_PATH_PRJ)/*.xpr)
# ifeq ($(XPR_PATHS),)
#     $(error В $(BR2_PACKAGE_EMBEDDEDHW_XLNX_PATH_PRJ) не найден *.xpr файл)
# endif
# ifneq ($(words $(XPR_PATHS)),1)
#     $(warning Найдено $(words $(XPR_PATHS)) .xpr файлов. Будет использован первый: $(firstword $(XPR_PATHS)))
# endif
# XPR_FILE := $(notdir $(firstword $(XPR_PATHS)))
# PRJ_NAME := $(basename $(XPR_FILE))
# endif

define EMBEDDEDHW_XLNX_BUILD_CMDS
	$(HWTOOLSXLNX) -mode tcl -source $(EMBEDDEDHW_XLNX_PKGDIR)hwrecovery.tcl -tclargs \
		$(BR2_PACKAGE_EMBEDDEDHW_XLNX_PATH_PRJ) $(BR2_PACKAGE_EMBEDDEDHW_XLNX_NM_BLOCK_DESIGN) $(BR2_PACKAGE_HW_SPECIFIED)
endef

EMBEDDEDHW_XLNX_INSTALL_TARGET = NO

$(eval $(generic-package))
