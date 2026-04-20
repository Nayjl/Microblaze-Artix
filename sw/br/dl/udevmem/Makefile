
O ?= build
PRJ_PATH ?= .
EXT_FILES ?= c
SRC_PATH ?= src
HED_PATH ?= src
BUILD_PATH := $(O)
EXT_ELF ?= 

CCC ?= arm-linux-gnueabihf-gcc
CFLAGS ?= -MMD -MP -I$(HED_PATH) -Wall -Wextra -g

LDFLAGS ?=
LDLIBS ?= # -lm

INSTALL ?= 
PREFIX ?= 

ifeq ($(PRJ_PATH), .)
	NAME_PRJ := $(notdir $(abspath .))
else
	NAME_PRJ := $(notdir $(PRJ_PATH))
endif

SRC_PATH := $(PRJ_PATH)/$(SRC_PATH)
BUILD_PATH := $(PRJ_PATH)/$(BUILD_PATH)

BIN ?= $(NAME_PRJ)
BIN := $(PRJ_PATH)/$(BIN)$(EXT_ELF)



SOURCES := $(shell find $(SRC_PATH) -type f -name '*.$(EXT_FILES)')
OBJECTS := $(patsubst $(SRC_PATH)/%.$(EXT_FILES), $(BUILD_PATH)/%.o, $(SOURCES))
DEPS := $(patsubst $(SRC_PATH)/%.$(EXT_FILES), $(BUILD_PATH)/%.d, $(SOURCES))


-include $(DEPS)


all: $(BIN)

$(BIN): $(OBJECTS)
	@echo "Линковка $(PRJ_PATH)/$@..."
	$(CCC) $(OBJECTS) $(LDFLAGS) $(LDLIBS) -o $(PRJ_PATH)/$@
	@echo "Готово: $(PRJ_PATH)/$@"

$(BUILD_PATH)/%.o: $(SRC_PATH)/%.$(EXT_FILES)
	@mkdir -p $(@D)
	@echo "Компиляция $< -> $@"
	$(CCC) $(CFLAGS) -c $< -o $@

build_obj: $(OBJECTS)
build_bin: 
	$(CCC) $(OBJECTS) $(LDFLAGS) $(LDLIBS) -o $(PRJ_PATH)/$@

clean:
	@echo "Удаление объектных файлов и целевого файла..."
	@rm -rfv $(BUILD_PATH)/* $(BIN)
	@echo "Очистка завершена"


DBG_USER ?= root
DBG_IP ?= 192.168.1.2
DBG_PATH ?= /root
DBG_PORT ?= 2345

REMOTE_EXECUTABLE_FILE ?= $(DBG_PATH)/$(NAME_TARGET_MAINELF)

run_program: copy_file_to_device $(NAME_TARGET_MAINELF)
	@echo "Запуск файла на целевую плату..."
	ssh $(DBG_USER)@$(DBG_IP) "$(REMOTE_EXECUTABLE_FILE)"

copy_file_to_device: remove_file_to_device $(NAME_TARGET_MAINELF)
	@echo "Копирование файла на целевую плату..."
	scp $(PRJ_PATH)/$(NAME_TARGET_MAINELF) $(DBG_USER)@$(DBG_IP):$(REMOTE_EXECUTABLE_FILE)

remove_file_to_device: $(NAME_TARGET_MAINELF)
	ssh $(DBG_USER)@$(DBG_IP) "rm -fv $(REMOTE_EXECUTABLE_FILE)"
	


run_local_gdb: $(NAME_TARGET_MAINELF)
	arm-linux-gnueabihf-gdb $(NAME_TARGET_MAINELF)

debug_experiment: $(NAME_TARGET_MAINELF)
	@echo "Запуск GDB для удаленной отладки..."
	/home/naydan/work/qmtech/sw/buildroot/output/host/bin/arm-buildroot-linux-gnueabihf-gdb $(NAME_TARGET_MAINELF) -ex "target remote $(DBG_IP):$(DBG_PORT)"

run_gdbserver: $(NAME_TARGET_MAINELF)
	ssh $(DBG_USER)@$(DBG_IP) "gdbserver :$(DBG_PORT) $(REMOTE_EXECUTABLE_FILE)"


.PHONY: clean all
