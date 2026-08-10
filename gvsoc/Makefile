# TernaryCore GVSoC Build
# ========================
#
# Builds the ternarycore device model as a gvsoc-compatible shared library.
#
# Prerequisites:
#   - gvsoc installed and sourced (sourceme.sh from gvsoc root)
#   - C++17 capable compiler (gcc >= 7 or clang >= 6)
#   - CMake >= 3.12
#
# Two build modes:
#   1. gvsoc plugin (shared library): installed into gvsoc's model search path
#   2. Standalone test (no gvsoc dep): verifies the core GEMM logic
#
# Usage:
#   make              — build both the shared library and standalone test
#   make test         — build and run the standalone logic test
#   make install      — install the gvsoc plugin into GVSOC_MODEL_DIR
#   make clean        — remove build artifacts

CXX      ?= g++
CXXFLAGS ?= -std=c++17 -O2 -fPIC
LDFLAGS  ?=

# Directory for build artifacts
BUILD_DIR ?= build

# gvsoc installation root — override if needed or set via environment
GVSOC_HOME ?= $(GVSOC_PATH)

# gvsoc include path (from the engine submodule)
GVSOC_INC  ?= $(GVSOC_HOME)/engine/include

# gvsoc library path (after building gvsoc-engine)
GVSOC_LIB  ?= $(GVSOC_HOME)/build/lib

# gvsoc model install dir — where gvsoc looks for .so device models
GVSOC_MODEL_DIR ?= $(GVSOC_HOME)/models/install

# -----------------------------------------------------------------------
# Targets
# -----------------------------------------------------------------------
.PHONY: all test install clean

all: $(BUILD_DIR)/libternarycore_device.so $(BUILD_DIR)/test_device_logic

# ---- gvsoc device plugin (shared library) ----
$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(BUILD_DIR)/ternarycore_device.o: ternarycore_device.cpp ternarycore_device.hpp $(BUILD_DIR)
	$(CXX) $(CXXFLAGS) -I$(GVSOC_INC) -c -o $@ $<

$(BUILD_DIR)/libternarycore_device.so: $(BUILD_DIR)/ternarycore_device.o
	$(CXX) -shared -o $@ $^ $(LDFLAGS) \
		-L$(GVSOC_LIB) -lgvsoc-engine \
		-Wl,-rpath,$(GVSOC_LIB)

# ---- standalone test (no gvsoc dependency) ----
$(BUILD_DIR)/test_device_logic: test_device_logic.cpp $(BUILD_DIR)
	$(CXX) -std=c++17 -O2 -o $@ $<

test: $(BUILD_DIR)/test_device_logic
	./$(BUILD_DIR)/test_device_logic

# ---- install device into gvsoc model path ----
# Keep the lib prefix so the installed name matches test_system.py /
# shared_lib="libternarycore_device.so" and the build artifact name.
install: $(BUILD_DIR)/libternarycore_device.so
	cp $< $(GVSOC_MODEL_DIR)/libternarycore_device.so
	@echo "Installed ternarycore device to $(GVSOC_MODEL_DIR)/libternarycore_device.so"
	@echo "Add to Python config with:"
	@echo '  soc.add_component("ternarycore_device", ..., shared_lib="libternarycore_device.so")'

# ---- cleanup ----
clean:
	rm -rf $(BUILD_DIR)
	$(MAKE) -C ../rvv clean 2>/dev/null; true

# ---- debug build ----
debug: CXXFLAGS += -g -DDEBUG -O0
debug: all

# ---- verbose build ----
VERBOSE ?= @
.SILENT: