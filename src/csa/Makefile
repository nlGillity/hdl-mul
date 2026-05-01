OUT    = csa_test
TB     = csa_tb.sv
MODULE = csa.sv
SOURCE = $(TB) $(MODULE)

.PHONY: run
run:
	iverilog -g2012 -o $(OUT) $(SOURCE)
	@vvp $(OUT)
	@rm  $(OUT)
			 