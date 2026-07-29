#==============================================================================
# Project      : RISCV64 Processor
# File         : config.mk
#
# Description  :
#   Central configuration file for the simulation environment.
#   All project paths and common variables are defined here.
#
# Author       : Siddhartha Chinta
# Target ISA   : RV64I
# Version      : 1.0
#==============================================================================


###############################################################################
# Project Root
###############################################################################

PROJECT_ROOT := ..


###############################################################################
# Source Directories
###############################################################################

RTL_DIR       := $(PROJECT_ROOT)/rtl
TB_DIR        := $(PROJECT_ROOT)/tb
PROGRAM_DIR   := $(PROJECT_ROOT)/programs


###############################################################################
# File Lists
###############################################################################

RTL_FLIST     := Flist.rtl
TB_FLIST      := Flist.tb


###############################################################################
# Simulation Output Directories
###############################################################################

BUILD_DIR     := build
XRUN_DIR      := xrun
LOG_DIR       := logs
WAVE_DIR      := waves
WORK_DIR      := work


###############################################################################
# Default Simulation Settings
###############################################################################

TOP           ?=
SIMULATOR     ?= xrun
