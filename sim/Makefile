# Global settings
MAKEFLAGS += --no-print-directory

# Paths
SV_DIR := ../sv
TOP    := tb_top

# ---------------------------------------------------------------------------
# DEFINE controls which `ifdef-guarded file inside include_files.sv gets
# pulled in. Pass it on the command line, e.g.:
#   make run     DEFINE=CHECK_ANAGRAM_SV
#   make runc    DEFINE=PRIME_NUMBER_SV
#   make compile DEFINE=SV_CODE1_SV
# Leave it unset to compile with no defines.
# ---------------------------------------------------------------------------
DEFINE ?=

ifneq ($(strip $(DEFINE)),)
  DEFINE_ARG := +define+$(DEFINE)
endif

# Targets
all: clean init compile run


# Clean
clean:
	@echo "Cleaning..."
	@rm -rf work transcript vsim.wlf *.log *.ucdb


# Init
init:
	@echo "Initializing work library..."
	@vlib work


# Compile (Plain SystemVerilog)
compile:
	@echo "Compiling SystemVerilog (DEFINE=$(DEFINE))..."
	@vlog -sv \
		$(DEFINE_ARG) \
		+incdir+$(SV_DIR) \
		$(SV_DIR)/tb_top.sv

# Run Terminal mode
runc:
	@$(MAKE) clean init compile DEFINE=$(DEFINE)
	@echo "Running in CLI mode..."
	@vsim -c \
		-l sim.log \
		-do "run -all; quit" \
		-voptargs="+acc" \
		$(TOP)

# Run (GUI mode)
run:
	@$(MAKE) runc DEFINE=$(DEFINE)
	@echo "Running in Questa GUI..."
	@vsim \
		-l sim.log \
		-voptargs="+acc" \
		$(TOP)