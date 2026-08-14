DETECTED_CROSS := $(shell command -v riscv64-unknown-elf-gcc 2>/dev/null || \
	command -v riscv64-elf-gcc 2>/dev/null || echo riscv64-unknown-elf-gcc)
CROSS ?= $(DETECTED_CROSS)
ARCH ?= rv64gcv_zvl128b
ABI ?= lp64d
CFLAGS ?= -march=$(ARCH) -mabi=$(ABI) -O3 -Wall -Wextra -Werror
INCLUDES ?= -I.

all: bitnet_rvv.o

bitnet_rvv.o: bitnet_rvv.c bitnet_rvv.h stdint.h
	$(CROSS) $(CFLAGS) $(INCLUDES) -c $< -o $@

clean:
	rm -f *.o *.s

.PHONY: all clean
