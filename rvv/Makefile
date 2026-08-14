CROSS ?= riscv64-unknown-elf-gcc
ARCH ?= rv64gcv_zvl128b
ABI ?= lp64d
CFLAGS ?= -march=$(ARCH) -mabi=$(ABI) -O3
INCLUDES ?= -I.

all: bitnet_rvv.o

bitnet_rvv.o: bitnet_rvv.c stdint.h
	$(CROSS) $(CFLAGS) $(INCLUDES) -c $< -o $@

clean:
	rm -f *.o *.s

.PHONY: all clean
