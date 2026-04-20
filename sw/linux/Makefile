
O ?= build
PRJ_PATH ?= .
EXT_FILES ?= cpp
SRC_PATH ?= src
HED_PATH ?= src
BUILD_PATH := $(O)
EXT_FILE ?= 

CROSS_COMPILE ?= arm-linux-gnueabihf-
CC ?= gcc
CXX ?= g++
COMPILYATOR := $(CROSS_COMPILE)$(CXX)
CFLAGS ?= -MMD -MP -I$(HED_PATH) -Wall -Wextra -g
CXXFLAGS ?= -MMD -MP -I$(HED_PATH) -Wall -Wextra -g
CLIBS ?=
CFLAGS += #-fPIC

LDFLAGS ?= #-shared
LDLIBS ?= #-lm

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
BIN := $(PRJ_PATH)/$(BIN)$(EXT_FILE)



SOURCES := $(shell find $(SRC_PATH) -type f -name '*.$(EXT_FILES)')
OBJECTS := $(patsubst $(SRC_PATH)/%.$(EXT_FILES), $(BUILD_PATH)/%.o, $(SOURCES))
DEPS := $(patsubst $(SRC_PATH)/%.$(EXT_FILES), $(BUILD_PATH)/%.d, $(SOURCES))


-include $(DEPS)


all: $(BIN)

$(BIN): $(OBJECTS)
	@echo "Динамическая $(PRJ_PATH)/$@..."
	$(COMPILYATOR) $(LDFLAGS) $(OBJECTS) $(LDLIBS) -o $(PRJ_PATH)/$@
	@echo "Готово: $(PRJ_PATH)/$@"

$(BUILD_PATH)/%.o: $(SRC_PATH)/%.$(EXT_FILES)
	@mkdir -p $(@D)
	@echo "<=================Компиляция $< -> $@=================>"
	$(COMPILYATOR) $(CXXFLAGS) $(CLIBS) -c $< -o $@

build_obj: $(OBJECTS)
build_bin: 
	$(COMPILYATOR) $(OBJECTS) $(LDFLAGS) $(LDLIBS) -o $(PRJ_PATH)/$@

clean:
	@echo "Удаление объектных файлов и целевого файла..."
	@rm -rfv $(BUILD_PATH)/* $(BIN)
	@echo "Очистка завершена"


DBG_USER ?= root
DBG_IP ?= 192.168.1.1
DBG_PATH ?= /root
DBG_PORT ?= 2345

REMOTE_EXECUTABLE_FILE ?= $(DBG_PATH)/$(BIN)

run_program: copy_file_to_device $(BIN)
	@echo "Запуск файла на целевую плату..."
	ssh $(DBG_USER)@$(DBG_IP) "$(REMOTE_EXECUTABLE_FILE)"

copy_file_to_device: remove_file_to_device $(BIN)
	@echo "Копирование файла на целевую плату..."
	scp -O $(BIN) $(DBG_USER)@$(DBG_IP):$(REMOTE_EXECUTABLE_FILE)

remove_file_to_device: $(BIN)
	ssh $(DBG_USER)@$(DBG_IP) "rm -fv $(REMOTE_EXECUTABLE_FILE)"
	


run_local_gdb: $(BIN)
	arm-linux-gnueabihf-gdb $(BIN)

debug_experiment: $(BIN)
	@echo "Запуск GDB для удаленной отладки..."
	/home/naydan/work/qmtech/sw/buildroot/output/host/bin/arm-buildroot-linux-gnueabihf-gdb $(BIN) -ex "target remote $(DBG_IP):$(DBG_PORT)"

run_gdbserver: $(BIN)
	ssh $(DBG_USER)@$(DBG_IP) "gdbserver :$(DBG_PORT) $(REMOTE_EXECUTABLE_FILE)"


.PHONY: clean all