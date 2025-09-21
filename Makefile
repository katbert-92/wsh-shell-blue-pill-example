# ===== Project Configuration =====
TARGET := blue_pill
BUILD ?= Debug

# ===== Toolchain =====
TOOLCHAIN_PREFIX := arm-none-eabi-
CC := $(TOOLCHAIN_PREFIX)gcc
OBJCOPY := $(TOOLCHAIN_PREFIX)objcopy
SIZE := $(TOOLCHAIN_PREFIX)size
MKDIR := mkdir -p
RM := rm -rf

EXAMPLE_DIR := ./blue_pill

# ===== Paths =====
SRC_DIR := -I.
SRC_DIR += -I$(EXAMPLE_DIR)/app
SRC_DIR += -I$(EXAMPLE_DIR)/app/shell
SRC_DIR += -I$(EXAMPLE_DIR)/app/usb
SRC_DIR += -I$(EXAMPLE_DIR)/platform
SRC_DIR += -I$(EXAMPLE_DIR)/platform/STM32CubeF1
SRC_DIR += -I$(EXAMPLE_DIR)/platform/STM32CubeF1/Drivers
SRC_DIR += -I$(EXAMPLE_DIR)/platform/STM32CubeF1/Drivers/STM32F1xx_HAL_Driver
SRC_DIR += -I$(EXAMPLE_DIR)/platform/STM32CubeF1/Drivers/STM32F1xx_HAL_Driver/Inc
SRC_DIR += -I$(EXAMPLE_DIR)/platform/STM32CubeF1/Drivers/STM32F1xx_HAL_Driver/Inc/Legacy
SRC_DIR += -I$(EXAMPLE_DIR)/platform/STM32CubeF1/Drivers/STM32F1xx_HAL_Driver/Src
SRC_DIR += -I$(EXAMPLE_DIR)/platform/STM32CubeF1/Drivers/STM32F1xx_HAL_Driver/Src/Legacy
SRC_DIR += -I$(EXAMPLE_DIR)/platform/STM32CubeF1/Middlewares/ST/STM32_USB_Device_Library/Core/Inc
SRC_DIR += -I$(EXAMPLE_DIR)/platform/STM32CubeF1/Middlewares/ST/STM32_USB_Device_Library/Class/CDC/Inc
SRC_DIR += -I$(EXAMPLE_DIR)/system

CORE_DIR := ./wsh-shell/src
BUILD_DIR := $(EXAMPLE_DIR)/build
OBJ_DIR := $(BUILD_DIR)/obj

# ===== Source Files =====
SRCS := 
SRCS += $(wildcard $(EXAMPLE_DIR)/app/*.c)
SRCS += $(wildcard $(EXAMPLE_DIR)/app/shell/*.c)
SRCS += $(wildcard $(EXAMPLE_DIR)/app/usb/*.c)
SRCS += $(wildcard $(EXAMPLE_DIR)/platform/*.c)
SRCS += $(EXAMPLE_DIR)/platform/STM32CubeF1/Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_ll_usb.c
SRCS += $(EXAMPLE_DIR)/platform/STM32CubeF1/Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal.c
SRCS += $(EXAMPLE_DIR)/platform/STM32CubeF1/Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_gpio.c
SRCS += $(EXAMPLE_DIR)/platform/STM32CubeF1/Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_rcc.c
SRCS += $(EXAMPLE_DIR)/platform/STM32CubeF1/Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_rcc_ex.c
SRCS += $(EXAMPLE_DIR)/platform/STM32CubeF1/Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_cortex.c
SRCS += $(EXAMPLE_DIR)/platform/STM32CubeF1/Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_flash.c
# SRCS += $(EXAMPLE_DIR)/platform/STM32CubeF1/Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_pwr.c
SRCS += $(EXAMPLE_DIR)/platform/STM32CubeF1/Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_pcd.c
SRCS += $(EXAMPLE_DIR)/platform/STM32CubeF1/Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_pcd_ex.c
SRCS += $(EXAMPLE_DIR)/platform/STM32CubeF1/Middlewares/ST/STM32_USB_Device_Library/Core/Src/usbd_core.c
SRCS += $(EXAMPLE_DIR)/platform/STM32CubeF1/Middlewares/ST/STM32_USB_Device_Library/Core/Src/usbd_ctlreq.c
SRCS += $(EXAMPLE_DIR)/platform/STM32CubeF1/Middlewares/ST/STM32_USB_Device_Library/Core/Src/usbd_ioreq.c
SRCS += $(EXAMPLE_DIR)/platform/STM32CubeF1/Middlewares/ST/STM32_USB_Device_Library/Class/CDC/Src/usbd_cdc.c
SRCS += $(EXAMPLE_DIR)/system/syscalls.c

SRCS += $(EXAMPLE_DIR)/platform/startup_stm32f103xb.s
CORE_SRCS := $(wildcard $(CORE_DIR)/*.c)

OBJS := $(SRCS:%=$(OBJ_DIR)/%.o)
CORE_OBJS := $(CORE_SRCS:$(CORE_DIR)/%.c=$(OBJ_DIR)/src/%.o)
ALL_OBJS := $(OBJS) $(CORE_OBJS)
DEPS := $(ALL_OBJS:.o=.d)

# ===== Compiler Flags =====
COMMON_FLAGS := $(SRC_DIR) -I$(CORE_DIR) -MMD -Wall -Wextra -Wpedantic -Wno-unused-parameter -Wno-format
CPU_FLAGS := -mcpu=cortex-m3 -mfloat-abi=soft -mthumb -DSTM32F103xB -DUSE_FULL_LL_DRIVER

LINKER_FLAGS += -Wl,-cref
LINKER_FLAGS += -Wl,-u,Reset_Handler
LINKER_FLAGS += -Wl,-Map=$(BUILD_DIR)/$(TARGET).map
LINKER_FLAGS += -specs=nano.specs
LINKER_FLAGS += -specs=nosys.specs
LINKER_FLAGS += -u _printf_float
LINKER_FLAGS += -Wl,--start-group -lc -lm -Wl,--end-group
LINKER_FLAGS += -Wl,--gc-sections
LINKER_FLAGS += -Wl,--print-memory-usage
LINKER_FLAGS += -Wl,--no-warn-rwx-segments

LINKER_SCRIPT := $(EXAMPLE_DIR)/platform/STM32F103XB_FLASH.ld

DEBUG_FLAGS := -O0 -g -DWSH_SHELL_ASSERT_ENABLE
RELEASE_FLAGS := -O2 -DNDEBUG

ifeq ($(BUILD),Debug)
    CFLAGS := $(COMMON_FLAGS) $(CPU_FLAGS) $(DEBUG_FLAGS)
else
    CFLAGS := $(COMMON_FLAGS) $(CPU_FLAGS) $(RELEASE_FLAGS)
endif

# ===== Targets =====
.PHONY: all clean flash

all: $(BUILD_DIR)/$(TARGET)

$(BUILD_DIR)/$(TARGET): $(ALL_OBJS)
	@echo "[LD] $@"
	@$(MKDIR) $(dir $@)
	@$(CC) -T$(LINKER_SCRIPT) $^ -o $@.elf $(LINKER_FLAGS) $(CPU_FLAGS)
	@echo "[OBJCOPY] $@.elf -> $@.hex"
	@$(OBJCOPY) -O ihex $@.elf $@.hex
	@echo "[OBJCOPY] $@.elf -> $@.bin"
	@$(OBJCOPY) -O binary $@.elf $@.bin
	@$(SIZE) $@.elf

$(OBJ_DIR)/%.c.o: %.c
	@echo "[CC] $<"
	@$(MKDIR) $(dir $@)
	@$(CC) $(CFLAGS) -c $< -o $@

$(OBJ_DIR)/%.s.o: %.s
	@echo "[AS] $<"
	@$(MKDIR) $(dir $@)
	@$(CC) $(CFLAGS) -c $< -o $@

$(OBJ_DIR)/src/%.o: $(CORE_DIR)/%.c
	@echo "[CC] $<"
	@$(MKDIR) $(dir $@)
	@$(CC) $(CFLAGS) -c $< -o $@

clean:
	@echo "[CLEAN] Removing build directory"
	@$(RM) $(BUILD_DIR)

flash:
	@echo "[FLASH] Programming device with OpenOCD"
	@openocd -f $(EXAMPLE_DIR)/stlink.cfg -f $(EXAMPLE_DIR)/stm32f1x.cfg -c "program $(BUILD_DIR)/$(TARGET).elf verify reset exit"

# ===== Include Dependencies =====
-include $(DEPS)
