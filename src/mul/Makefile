OUT        = mul_test
TB         = mul_tb.sv
MODULE     = mul.sv
SUBMODULES = ../csa/csa.sv ../radix4/radix4.sv
SOURCE     = $(TB) $(SUBMODULES) $(MODULE)

.PHONY: run
run:
	iverilog -g2012 -I. -o $(OUT) $(SOURCE)
	@vvp $(OUT)
	@rm  $(OUT)