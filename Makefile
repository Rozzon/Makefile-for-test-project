CROSS_COMPILE := /usr/bin/

CC = $(CROSS_COMPILE)gcc
AS = $(CROSS_COMPILE)gcc
LD = $(CROSS_COMPILE)ld
OC = $(CROSS_COMPILE)objcopy
OD = $(CROSS_COMPILE)objdump
NM = $(CROSS_COMPILE)nm
RE = $(CROSS_COMPILE)readelf
SZ = $(CROSS_COMPILE)size

quiet-command = $(if $(2),$(if $(E),@$1,@echo $2 && $1),@$1)
#MAKEFLAGS += --no-print-directory

# Directories
SRC_DIR := src
OBJ_DIR := obj
IMG_DIR := image

# Source files
C_SRC := $(shell find $(SRC_DIR) -name "*.c")
ASM_SRC := $(shell find $(SRC_DIR) -name "*.S")

# Object files
C_OBJ := $(patsubst $(SRC_DIR)/%.c, $(OBJ_DIR)/%.o, $(C_SRC))
ASM_OBJ := $(patsubst $(SRC_DIR)/%.S, $(OBJ_DIR)/%.o, $(ASM_SRC))


# Executable and Map file
EXE := $(IMG_DIR)/my_program
MAP := $(IMG_DIR)/my_program.map

# Compiler Flags
CFLAGS := -Wall -Wextra

# Linker Flags
LDFLAGS := -lm  # Add any additional linker flags here

# Targets
all: prepare $(EXE)

$(EXE): $(C_OBJ)
	$(CC) $(CFLAGS) $(LDFLAGS) $^ -o $@
	$(OD) -D $@ > $(MAP)

$(C_OBJ): $(OBJ_DIR)/%.o : $(SRC_DIR)/%.c
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

prepare:
	@mkdir -p $(OBJ_DIR)
	@mkdir -p $(IMG_DIR)

clean:
	rm -rf $(OBJ_DIR) $(IMG_DIR)

test:
	@echo $(C_SRC)
	@echo $(C_OBJ)

.PHONY: all clean

