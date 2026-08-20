DETECTED_CROSS := $(shell command -v riscv64-unknown-elf-gcc 2>/dev/null || \
	command -v riscv64-elf-gcc 2>/dev/null || echo riscv64-unknown-elf-gcc)
CROSS ?= $(DETECTED_CROSS)
ARCH ?= rv64gcv_zvl128b
# The G extension includes F and D, so use the double-precision ABI by
# default. Select lp64 explicitly for an integer-only ABI/toolchain.
ABI ?= lp64d
CFLAGS ?= -march=$(ARCH) -mabi=$(ABI) -O3 -Wall -Wextra -Werror
# The default keeps the RVV object usable with bare-metal toolchains that
# expose riscv_vector.h but do not ship a C library/sysroot. Hosted builds can
# use the platform stdint.h with FREESTANDING=0.
FREESTANDING ?= 1
ifeq ($(FREESTANDING),1)
CFLAGS += -DTERNARYCORE_FREESTANDING
INCLUDES ?= -I.
else
INCLUDES ?=
endif

all: bitnet_rvv.o

bitnet_rvv.o: bitnet_rvv.c bitnet_rvv.h stdint.h ternarycore_freestanding_stdint.h
	$(CROSS) $(CFLAGS) $(INCLUDES) -c $< -o $@

clean:
	rm -f *.o *.s

.PHONY: all clean
