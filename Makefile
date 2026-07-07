CUR_DIR_PRJ := $(shell pwd)
RED := \033[0;31m
GREEN := \033[0;32m
YELLOW := \033[0;33m
BLUE := \033[0;34m
BOLD := \033[1m
NC := \033[0m # No Color (сброс)
#---------------------------------------------------------------------------------------------------------------
PATH_SRC_BR ?= $(PTH_BR)
VERSION_BR ?= "2024.02.1"
PATH_BUILD_BR_EXTERNAL := sw/br
#---------------------------------------------------------------------------------------------------------------
define import-br2-variable
$(eval $(1) := $(shell grep '^$(1)=' $(PATH_BUILD_BR_EXTERNAL)/output/.config 2>/dev/null | cut -d'=' -f2- | tr -d '"' | xargs))
endef
$(eval $(call import-br2-variable,BR2_EXTERNAL_OVERLAY_PKGS_PATH))
$(eval $(call import-br2-variable,BR2_TARGET_GENERIC_HOSTNAME))
$(eval $(call import-br2-variable,BR2_PACKAGE_XLNX_TOOLS_HW))
$(eval $(call import-br2-variable,BR2_PACKAGE_XLNX_HW_SPECIFIED))
$(eval $(call import-br2-variable,BR2_PACKAGE_XLNX_HW_PRJ))
$(eval $(call import-br2-variable,BR2_PACKAGE_XLNX_HW_BD))
ifneq ($(wildcard $(PATH_BUILD_BR_EXTERNAL)/output/.config),)
# ifndef BR2_EXTERNAL_CUSTOM_PACKAGE_PATH
#     $(error BR2_EXTERNAL_CUSTOM_PACKAGE_PATH не определена!)
# endif
endif
#---------------------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------------------
XLNX_TLS_HW = $(BR2_PACKAGE_XLNX_TOOLS_HW)
VIVADO_PRJ_PATH = $(BR2_PACKAGE_XLNX_HW_PRJ)
VIVADO_BD_PATH = $(BR2_PACKAGE_XLNX_HW_BD)
HW_SPEC_PATH = $(BR2_PACKAGE_XLNX_HW_SPECIFIED)
#---------------------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------------------
.PHONY: all rebuild-all rebuild-hw rebuild-sw clean-all clean-sw clean-hw
all: xlnx-hw-all buildroot-all

clean-all: clean-sw clean-hw
	@echo "$(GREEN)<========================All clean========================>$(NC)"

clean-sw: buildroot-clean

clean-hw: xlnx-hw-clean-all

rebuild-all: rebuild-hw rebuild-sw

rebuild-hw: xlnx-hw-runbitstream xlnx-hw-export

rebuild-sw: host-device-tree-xlnx-dirclean host-embeddedsw-xlnx-dirclean arm-trusted-firmware-dirclean uboot-dirclean buildroot-build

.PHONY: buildroot-all buildroot-build list-defconfigs %_defconfig
list-defconfigs:
	$(MAKE) -C $(PATH_BUILD_BR_EXTERNAL) \
		PATH_SRC_BR=$(PATH_SRC_BR) \
		VERSION_BR=$(VERSION_BR) \
		$@
defconfig:
	$(MAKE) -C $(PATH_BUILD_BR_EXTERNAL) \
		PATH_SRC_BR=$(PATH_SRC_BR) \
		VERSION_BR=$(VERSION_BR) \
		$@
	@echo "$(GREEN)<========================Instalation default config buildroot========================>$(NC)"
buildroot-build: 
	$(MAKE) -C $(PATH_BUILD_BR_EXTERNAL) $@
	@echo "$(GREEN)<========================Successfully build buildroot========================>$(NC)"
buildroot-all:
	$(MAKE) -C $(PATH_BUILD_BR_EXTERNAL) \
		all
	@echo "$(GREEN)<========================All Successfully buildroot========================>$(NC)"
%_defconfig:
	$(MAKE) -C $(PATH_BUILD_BR_EXTERNAL) \
		PATH_SRC_BR=$(PATH_SRC_BR) \
		VERSION_BR=$(VERSION_BR) \
		$@
	@echo "$(GREEN)<========================Instalation config buildroot========================>$(NC)"
.PHONY: buildroot-help
buildroot-help:
	$(MAKE) -C $(PATH_BUILD_BR_EXTERNAL) $@
.PHONY: buildroot-cmd-%
buildroot-cmd-%:
	$(MAKE) -C $(PATH_BUILD_BR_EXTERNAL) $@
cmd-%:
	$(MAKE) -C $(PATH_BUILD_BR_EXTERNAL) $*
#---------------------------------------------------------------------------------------------------------------
.PHONY: buildroot-saveconfig linux-saveconfig uboot-saveconfig
buildroot-saveconfig:
	$(MAKE) -C $(PATH_BUILD_BR_EXTERNAL) $@
	@echo "$(GREEN)<========================Save config buildroot========================>$(NC)"
linux-saveconfig:
	$(MAKE) -C $(PATH_BUILD_BR_EXTERNAL) $@
	@echo "$(GREEN)<========================Save config linux========================>$(NC)"
uboot-saveconfig:
	$(MAKE) -C $(PATH_BUILD_BR_EXTERNAL) $@
	@echo "$(GREEN)<========================Save config uboot========================>$(NC)"
.PHONY: buildroot-fullsaveconfig linux-fullsaveconfig uboot-fullsaveconfig
buildroot-fullsaveconfig:
	$(MAKE) -C $(PATH_BUILD_BR_EXTERNAL) $@
	@echo "$(GREEN)<========================Full save config uboot========================>$(NC)"
linux-fullsaveconfig:
	$(MAKE) -C $(PATH_BUILD_BR_EXTERNAL) $@
	@echo "$(GREEN)<========================Full save config uboot========================>$(NC)"
uboot-fullsaveconfig:
	$(MAKE) -C $(PATH_BUILD_BR_EXTERNAL) $@
	@echo "$(GREEN)<========================Full save config uboot========================>$(NC)"
#---------------------------------------------------------------------------------------------------------------
.PHONY: buildroot-nconfig uboot-nconfig linux-nconfig
buildroot-nconfig: 
	$(MAKE) -C $(PATH_BUILD_BR_EXTERNAL) $@
uboot-nconfig: 
	$(MAKE) -C $(PATH_BUILD_BR_EXTERNAL) $@
linux-nconfig:
	$(MAKE) -C $(PATH_BUILD_BR_EXTERNAL) $@
#---------------------------------------------------------------------------------------------------------------
.PHONY: buildroot-menuconfig uboot-menuconfig linux-menuconfig
buildroot-menuconfig:
	$(MAKE) -C $(PATH_BUILD_BR_EXTERNAL) $@
uboot-menuconfig: 
	$(MAKE) -C $(PATH_BUILD_BR_EXTERNAL) $@
linux-menuconfig: 
	$(MAKE) -C $(PATH_BUILD_BR_EXTERNAL) $@
#---------------------------------------------------------------------------------------------------------------
.PHONY: buildroot-xconfig uboot-xconfig linux-xconfig
buildroot-xconfig:
	$(MAKE) -C $(PATH_BUILD_BR_EXTERNAL) $@
uboot-xconfig: 
	$(MAKE) -C $(PATH_BUILD_BR_EXTERNAL) $@
linux-xconfig: 
	$(MAKE) -C $(PATH_BUILD_BR_EXTERNAL) $@
#---------------------------------------------------------------------------------------------------------------
.PHONY: buildroot-clean
buildroot-clean:
	$(MAKE) -C $(PATH_BUILD_BR_EXTERNAL) $@
	@echo "$(GREEN)<========================Clean buidlroot project========================>$(NC)"
#---------------------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------------------
.PHONY: linux-rebuild uboot-rebuild host-device-tree-xlnx-rebuild host-embeddedsw-xlnx-rebuild
linux-rebuild:
	$(MAKE) -C $(PATH_BUILD_BR_EXTERNAL) buildroot-cmd-$@
	@echo "$(GREEN)<========================Rebuild kernel========================>$(NC)"
uboot-rebuild:
	$(MAKE) -C $(PATH_BUILD_BR_EXTERNAL) buildroot-cmd-$@
	@echo "$(GREEN)<========================Rebuild uboot========================>$(NC)"
host-device-tree-xlnx-rebuild:
	$(MAKE) -C $(PATH_BUILD_BR_EXTERNAL) buildroot-cmd-$@
	@echo "$(GREEN)<========================Rebuild device-tree-xlnx========================>$(NC)"
host-embeddedsw-xlnx-rebuild:
	$(MAKE) -C $(PATH_BUILD_BR_EXTERNAL) buildroot-cmd-$@
	@echo "$(GREEN)<========================Rebuild embeddedsw-xlnx========================>$(NC)"

.PHONY: linux-dirclean uboot-dirclean host-device-tree-xlnx-dirclean host-embeddedsw-xlnx-dirclean arm-trusted-firmware-dirclean
linux-dirclean:
	$(MAKE) -C $(PATH_BUILD_BR_EXTERNAL) buildroot-cmd-$@
	@echo "$(GREEN)<========================Clean kernel========================>$(NC)"
uboot-dirclean:
	$(MAKE) -C $(PATH_BUILD_BR_EXTERNAL) buildroot-cmd-$@
	@echo "$(GREEN)<========================Clean uboot========================>$(NC)"
host-device-tree-xlnx-dirclean:
	$(MAKE) -C $(PATH_BUILD_BR_EXTERNAL) buildroot-cmd-$@
	@echo "$(GREEN)<========================Clean device-tree-xlnx========================>$(NC)"
host-embeddedsw-xlnx-dirclean:
	$(MAKE) -C $(PATH_BUILD_BR_EXTERNAL) buildroot-cmd-$@
	@echo "$(GREEN)<========================Clean embeddedsw-xlnx========================>$(NC)"
arm-trusted-firmware-dirclean:
	$(MAKE) -C $(PATH_BUILD_BR_EXTERNAL) buildroot-cmd-$@
	@echo "$(GREEN)<========================Clean arm-trusted-firmware========================>$(NC)"

.PHONY: linux-% uboot-% host-device-tree-xlnx-% host-embeddedsw-xlnx-%
linux-%:
	$(MAKE) -C $(PATH_BUILD_BR_EXTERNAL) buildroot-cmd-$@
uboot-%:
	$(MAKE) -C $(PATH_BUILD_BR_EXTERNAL) buildroot-cmd-$@
host-device-tree-xlnx-%:
	$(MAKE) -C $(PATH_BUILD_BR_EXTERNAL) buildroot-cmd-$@
host-embeddedsw-xlnx-%:
	$(MAKE) -C $(PATH_BUILD_BR_EXTERNAL) buildroot-cmd-$@
#---------------------------------------------------------------------------------------------------------------
.PHONY: xlnx-hw-all xlnx-hw-export xlnx-hw-clean-all xlnx-hw-prj-recovery
xlnx-hw-all: xlnx-hw-prj-recovery xlnx-hw-runbitstream xlnx-hw-export
	@echo "$(GREEN)<========================All Successfully hardware part========================>$(NC)"

xlnx-hw-clean-all:
	$(MAKE) -C hw \
		VIVADO_PRJ_PATH=$(VIVADO_PRJ_PATH) \
		clean-all
	@echo "$(GREEN)<========================All clean hardware part========================>$(NC)"
xlnx-hw-export:
	$(MAKE) -C hw \
		XLNX_TLS_HW=$(XLNX_TLS_HW) \
		VIVADO_PRJ_PATH=$(VIVADO_PRJ_PATH) \
		HW_SPEC_PATH=$(HW_SPEC_PATH) \
		$@
	@echo "$(GREEN)<========================Successfully export hardware specification========================>$(NC)"
xlnx-hw-runbitstream:
	$(MAKE) -C hw \
		XLNX_TLS_HW=$(XLNX_TLS_HW) \
		VIVADO_PRJ_PATH=$(VIVADO_PRJ_PATH) \
		$@
	@echo "$(GREEN)<========================Successfully build bitstream hardware========================>$(NC)"
xlnx-hw-blockdesign-recovery:
	$(MAKE) -C hw \
		XLNX_TLS_HW=$(XLNX_TLS_HW) \
		VIVADO_PRJ_PATH=$(VIVADO_PRJ_PATH) \
		VIVADO_BD_PATH=$(VIVADO_BD_PATH) \
		$@
xlnx-hw-prj-recovery:
	$(MAKE) -C hw \
		XLNX_TLS_HW=$(XLNX_TLS_HW) \
		VIVADO_PRJ_PATH=$(VIVADO_PRJ_PATH) \
		VIVADO_BD_PATH=$(VIVADO_BD_PATH) \
		$@
	@echo "$(GREEN)<========================Successfully recovery project hardware========================>$(NC)"
#---------------------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------------------
