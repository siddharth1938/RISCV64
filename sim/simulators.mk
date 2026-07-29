#==============================================================================
# Project      : RISCV64 Processor
# File         : simulators.mk
#
# Description  :
#   Simulator-specific configuration for Verilator and Cadence Xcelium.
#
# Author       : Siddhartha Chinta
# Target ISA   : RV64I
# Version      : 1.0
#==============================================================================


###############################################################################
# Common Compiler Options
###############################################################################

COMMON_INC = \
    +incdir+$(INCLUDE_DIR)

COMMON_DEFINES =

COMMON_OPTIONS =


###############################################################################
# Verilator Configuration
###############################################################################

VERILATOR       := verilator

VERILATOR_FLAGS := \
    --binary \
    --trace \
    --Wall \
    --timing \
    --sv


###############################################################################
# Cadence Xcelium Configuration
###############################################################################

XRUN := xrun

XRUN_FLAGS := \
    -64bit \
    -sv \
    -access +rwc \
    -linedebug
