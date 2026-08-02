CROSS ?= riscv64-elf-gcc
ARCH ?= rv64gcv_zvl128b
ABI ?= lp64d
CFLAGS = -march=$(ARCH) -mabi=$(ABI) -O3 -nostdlib -nostdinc
INCLUDES = -I.

all: bitnet_rvv.o

bitnet_rvv.o: bitnet_rvv.c stdint.h
	$(CROSS) $(CFLAGS) $(INCLUDES) -c $< -o $@

# Minimal stdint for bare-metal compilation
stdint.h:
	@echo '#ifndef _STDINT_H' > $@
	@echo '#define _STDINT_H' >> $@
	@echo 'typedef signed char int8_t;' >> $@
	@echo 'typedef short int16_t;' >> $@
	@echo 'typedef int int32_t;' >> $@
	@echo 'typedef long long int64_t;' >> $@
	@echo 'typedef unsigned char uint8_t;' >> $@
	@echo 'typedef unsigned short uint16_t;' >> $@
	@echo 'typedef unsigned int uint32_t;' >> $@
	@echo 'typedef unsigned long long uint64_t;' >> $@
	@echo '#endif' >> $@

clean:
	rm -f *.o *.s stdint.h

.PHONY: all clean
