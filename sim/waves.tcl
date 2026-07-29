#==============================================================================
# Project      : RISCV64 Processor
# File         : waves.tcl
#
# Description  :
#   Xcelium waveform configuration
#
#==============================================================================

# Open SHM waveform database
database -open waves -into ../waves/waves.shm -default

# Probe entire design hierarchy
probe -create -all -depth all

# Run until $finish
run

# Exit simulator
exit
