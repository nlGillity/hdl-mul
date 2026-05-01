# TARGET select
TARGET = tb

# TARGET code reuse select
EXAMPLE_REUSE =

# Top simulation module select
TOP = tb
export TOP

# Output directory
OUT = $(TARGET)/out
export OUT

# Waveforms save enable
WAVES = 1
export WAVES

# Coverage print enable
COV = 0
export COV

# Package-based testbench flag
WITH_PKG = 0

# DUT file name if package-based testbench
DUT = mul

SUBMODULES = ./src/csa/csa.sv ./src/radix4/radix4.sv

# Interface name if package-based testbench
INTF = mul_intf

# TCL for Questa
TCL = questa.tcl

# Temporary directories and files
TEMP_DIRS   = $(shell find -maxdepth 2 -path "./*/*" -type d)
TEMP_FILES  = $(shell find -mindepth 2 ! -wholename "*/*.*v" -not -path "./*/*" -type f)
TEMP_FILES += $(shell find -name "*.ini" -type f)

# Compilation options
COMP_OPTS = 

# Simulation options
SIM_OPTS = -c
ifneq ($(WITH_PKG),0)
	SIM_OPTS += +incdir=$(TARGET) -permit_unmatched_virtual_intf
	ifneq ($(EXAMPLE_REUSE),)
		SIM_OPTS += +incdir=$(EXAMPLE_REUSE)
	endif
endif

# Compile Verilog / SystemVerilog files from TARGET directory
ifeq ($(WITH_PKG),0)
	VERILOG = $(shell find $(TARGET)/ -name "*.*v")
else
	ifneq ($(EXAMPLE_REUSE),)
		VERILOG += $(shell find $(EXAMPLE_REUSE)/ -name "*_pkg.*v")
		VERILOG += $(EXAMPLE_REUSE)/$(INTF).sv
		TCL = questa_pkg.tcl
	else
		ifneq ($(INTF),)
			VERILOG += $(TARGET)/$(INTF).sv
			TCL = questa_pkg.tcl
		endif
	endif
	VERILOG += $(shell find $(TARGET)/ -name "*_pkg.*v")
	VERILOG += ./src/$(DUT)/$(DUT).sv
	VERILOG += $(SUBMODULES)
	VERILOG += $(TARGET)/$(TOP).sv
endif

# All Verilog / SystemVerilog files from TARGET directory
ALL_VERILOG = $(shell find $(TARGET)/ -name "*.*v")

# Verbosity
v = @

.PHONY: run clean clean_all

# Run target
run: $(OUT)/compile.stamp
	@echo "Running $(TARGET) (log file at $(OUT)/sim.log) ..."
	$(v)vsim $(SIM_OPTS) work.$(TOP) -work $(OUT)/work -do $(TCL) \
		-voptargs="+acc" -l $(OUT)/sim.log -wlf $(OUT)/sim.wlf > $(OUT)/sim.log

# Clean target
clean:
	@echo "Removing $(OUT) ..."
	$(v)rm -rf $(OUT)

# Clean all target
clean_all:
	@echo "Cleaning ..."
	@for dir in $(TEMP_DIRS); do \
		echo "Removing $$dir ..."; \
		rm -rf $$dir; \
	done
	@for file in $(TEMP_FILES); do \
		echo "Removing $$file ..."; \
		rm $$file; \
	done
	@echo "Cleaning done"

# Compile target
ifneq ($(ALL_VERILOG),) # Guard on compilation only from existing TARGET
$(OUT)/compile.stamp: $(ALL_VERILOG) | $(OUT)
	@echo "Compiling $(TARGET) (log file at $(OUT)/compile.log) ..."
	$(v)vlib $(OUT)/work > $(OUT)/compile.log
	$(v)vmap work $(OUT)/work >> $(OUT)/compile.log
	$(v)vlog -sv $(COMP_OPTS) -work work $(VERILOG) >> $(OUT)/compile.log
	@touch $@
endif

# Output directory target
$(OUT):
	@mkdir -p $@