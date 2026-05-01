OUT    = radix4_test
TB     = radix4_tb.sv
MODULE = radix4.sv
SOURCE = $(TB) $(MODULE)

.PHONY: run
run:
	iverilog -g2012 -o $(OUT) $(SOURCE)
	@vvp $(OUT)
	@rm  $(OUT)
			 