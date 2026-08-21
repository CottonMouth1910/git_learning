# ============================================================
# Global Make Settings
# ============================================================

MAKEFLAGS += --no-print-directory

# ============================================================
# Project Paths
# ============================================================

SV_DIR   := ../sv
RTL_DIR  := ../rtl
LIB_DIR  := ../lib

# UVM Installation
UVM_DIR := /cadtools/questasim/verilog_src/uvm-1.1d/src

# Top-level module
TOP := tb_top

# Work library
WORKLIB := work

# Compile stamp file
COMPILE_STAMP := .compile_stamp

# ============================================================
# Source Files
# ============================================================

RTL_SRCS := $(shell find $(RTL_DIR) -name "*.sv")
SV_SRCS  := $(shell find $(SV_DIR)  -name "*.sv")

SRCS := $(RTL_SRCS) $(SV_SRCS)

# ============================================================
# User Variables
# ============================================================

t     ?= base_test
seed  ?= random
verb  ?= UVM_LOW

# ============================================================
# Log Structure
# ============================================================

DATE     := $(shell date +%Y%m%d)

LOG_DIR  := logs/$(DATE)

RUN_NAME := $(t)_$(seed)

LOG      := $(LOG_DIR)/$(RUN_NAME).log
UCDB     := $(LOG_DIR)/$(RUN_NAME).ucdb

# ============================================================
# Phony Targets
# ============================================================

.PHONY: \
	clean \
	rebuild \
	uvm_compile \
	uvm_runc \
	waves \
	uvm_run \
	regr \
	cov_txt \
	cov_html \
	help \
	dirs

# ============================================================
# Create Log Directory
# ============================================================

dirs:
	@mkdir -p $(LOG_DIR)

# ============================================================
# Cleanup
# ============================================================

clean:
	@echo ""
	@echo "CLEANING..."
	@echo ""

	@rm -rf \
		work \
		transcript \
		vsim.wlf \
		logs \
		$(COMPILE_STAMP)

# ============================================================
# Full Rebuild
# ============================================================

rebuild: clean uvm_compile

# ============================================================
# Incremental Compile Tracking
# ============================================================

$(COMPILE_STAMP): $(SRCS)
	@if [ ! -d "$(WORKLIB)" ]; then \
		echo ""; \
		echo "INITIALIZING WORK LIBRARY..."; \
		echo ""; \
		vlib $(WORKLIB); \
	fi

	@echo ""
	@echo "COMPILING..."
	@echo ""

	@vlog -sv \
		-work $(WORKLIB) \
		+incdir+$(UVM_DIR) \
		+incdir+$(RTL_DIR) \
		+incdir+$(SV_DIR) \
		+cover \
		$(SV_DIR)/tb_top.sv

	@touch $(COMPILE_STAMP)

# User-facing compile target
uvm_compile: $(COMPILE_STAMP)

# ============================================================
# Quick Terminal Run (NO COVERAGE)
# ============================================================

uvm_runc: $(COMPILE_STAMP) dirs
	@echo ""
	@echo "RUNNING : $(t)"
	@echo "SEED    : $(seed)"
	@echo "LOG     : $(LOG)"
	@echo ""

	@timeout 30m \
	vsim -lic_noqueue -c \
		-sv_seed $(seed) \
		-do "run -all; exit" \
		+UVM_TESTNAME=$(t) \
		+UVM_VERBOSITY=$(verb) \
		-voptargs="+acc" \
		$(TOP) | tee $(LOG)

	@echo ""
	@echo "RUN COMPLETE"
	@echo ""

# ============================================================
# Open Waves (NO COVERAGE)
# ============================================================

waves: $(COMPILE_STAMP) dirs
	@echo ""
	@echo "OPENING WAVES : $(t)"
	@echo "SEED          : $(seed)"
	@echo "LOG           : $(LOG)"
	@echo ""

	@vsim -lic_noqueue \
		-sv_seed $(seed) \
		-do run.do \
		+UVM_TESTNAME=$(t) \
		+UVM_VERBOSITY=$(verb) \
		-voptargs="+acc" \
		$(TOP) | tee $(LOG)

	@echo ""
	@echo "WAVE SESSION COMPLETE"
	@echo ""

# ============================================================
# Run + Waves (NO COVERAGE)
# ============================================================

uvm_run: uvm_runc
	@$(MAKE) waves t=$(t) seed=$(seed)

# ============================================================
# Regression Run (WITH COVERAGE)
# ============================================================

regr: $(COMPILE_STAMP) dirs
	@echo ""
	@echo "REGRESSION : $(t)"
	@echo "SEED       : $(seed)"
	@echo "LOG        : $(LOG)"
	@echo ""

	@timeout 30m \
	vsim -lic_noqueue -c \
		-coverage \
		-sv_seed $(seed) \
		-do "coverage save -onexit $(UCDB); run -all; exit" \
		+UVM_TESTNAME=$(t) \
		+UVM_VERBOSITY=$(verb) \
		-voptargs="+acc" \
		$(TOP) | tee $(LOG)

	@echo ""
	@echo "UCDB SAVED : $(UCDB)"
	@echo ""

# ============================================================
# Coverage Reports
# ============================================================

cov_txt:
	@echo ""
	@echo "GENERATING TEXT COVERAGE REPORT..."
	@echo ""

	@vsim -cvgperinstance \
		-viewcov $(UCDB) \
		-do "coverage report -file $(LOG_DIR)/coverage.txt -detail"

cov_html:
	@echo ""
	@echo "GENERATING HTML COVERAGE REPORT..."
	@echo ""

	@vcover report \
		-details \
		-html $(UCDB)

# ============================================================
# Help
# ============================================================

help:
	@echo ""
	@echo "Targets:"
	@echo ""
	@echo "  make uvm_compile"
	@echo "  make uvm_runc t=<test> seed=<seed>"
	@echo "  make waves    t=<test> seed=<seed>"
	@echo "  make uvm_run  t=<test> seed=<seed>"
	@echo "  make regr     t=<test> seed=<seed>"
	@echo "  make rebuild"
	@echo "  make clean"
	@echo ""