#==============================================================================
# RISCV64 Processor
# Generic Verilator Makefile
#==============================================================================

TOP ?= tb_pc

BUILD_DIR = ../build
WAVE_DIR  = ../waves

RTL_FLIST = Flist.rtl
TB_FLIST  = Flist.tb

VERILATOR = verilator

VERILATOR_FLAGS =               \
	--binary                    \
	--trace                     \
	--Wall                      \
	-Wno-IMPORTSTAR             \
	-Wno-UNUSEDSIGNAL           \
	-Wno-UNUSEDPARAM            \
	--top-module $(TOP)         \
	-Wno-SYNCASYNCNET			\
	--Mdir $(BUILD_DIR)

.PHONY: clean build run wave

build:
	mkdir -p $(BUILD_DIR)
	mkdir -p $(WAVE_DIR)

	$(VERILATOR) $(VERILATOR_FLAGS) \
	-F $(RTL_FLIST) \
	-F $(TB_FLIST)

run:
	$(BUILD_DIR)/V$(TOP)

wave:
	gtkwave $(WAVE_DIR)/$(TOP).vcd &

clean:
	rm -rf $(BUILD_DIR)
	rm -f $(WAVE_DIR)/*.vcd
	