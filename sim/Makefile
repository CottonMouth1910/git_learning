# Global settings
MAKEFLAGS += --no-print-directory

# Paths
SV_DIR := ../sv
TOP    := tb_top

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
	@echo "🔧 Compiling SystemVerilog..."
	@vlog -sv \
		+incdir+$(SV_DIR) \
		$(SV_DIR)/tb_top.sv

# Runc Terminal mode
runc:
	@$(MAKE) clean init compile
	@echo "Running in CLI mode..."
	@vsim -c \
		-l sim.log \
		-do "run -all; quit" \
		-voptargs="+acc" \
		$(TOP)

# Run (GUI mode)
run:
	@$(MAKE) runc
	@echo "Running in Questa GUI..."
	@vsim \
		-l sim.log \
		-voptargs="+acc" \
		$(TOP)