module radix4_tb;

    localparam int DATA_WIDTH     = 8;
    localparam int CLOCK_PERIOD   = 10;
    localparam int RESET_DURATION = 20;
    localparam int TEST_NUM       = 100;

    logic clk;
    int   clk_cnt;

    logic error_stob;
    int   error_cnt;
    
    //====================================================================
    // Wiring with DUT and check variables
    //====================================================================

    logic [DATA_WIDTH - 1:0] num, next_num;
    logic [             2:0] sel, next_sel;
    logic [DATA_WIDTH + 1:0] pp;

    int signed expected;

    //====================================================================
    // Device Under Test
    //====================================================================

    radix4 #(DATA_WIDTH) DUT (
        .num ( num ),
        .sel ( sel ),
        .pp  ( pp  )
    );

    //====================================================================
    // Genetrial proccesses/tasks
    //====================================================================

    initial begin
        $dumpfile("sim.vcd");
        $dumpvars(0, radix4_tb);
    end

    initial begin
        clk <= 1'b0;
        forever #(CLOCK_PERIOD / 2) clk <= ~clk;
    end

    initial begin
        forever begin
            @(posedge clk);
            clk_cnt += 1;
        end
    end

    task reset();
        num        <= '0;
        sel        <= '0;
        error_stob <= 1'b0;
        repeat (RESET_DURATION) @(posedge clk);
    endtask

    //====================================================================
    // Funbctions
    //====================================================================

    // DUT stimulation functions
    //--------------------------------------------------------------------

    function void prepare();
        next_num = $urandom_range(2 ** DATA_WIDTH - 1);
        next_sel = $urandom_range(7, 0);
        case (next_sel)
            3'b000: expected = 0;
            3'b001: expected =      signed'(next_num);
            3'b010: expected =      signed'(next_num);
            3'b011: expected =  2 * signed'(next_num);
            3'b100: expected = -2 * signed'(next_num);
            3'b101: expected = -1 * signed'(next_num);
            3'b110: expected = -1 * signed'(next_num);
            3'b111: expected = 0;
        endcase
    endfunction

    task drive();
        num <= next_num;
        sel <= next_sel;
    endtask

    task delay( input int min, input int max );
        repeat ($urandom_range(min, max)) @(posedge clk);
    endtask

    // Check functions
    //--------------------------------------------------------------------

    task stobe();
        error_stob <= 1'b1;
        @(posedge clk);
        error_stob <= 1'b0;
    endtask

    task check();
        if (signed'(pp) !== expected) begin
            $display(
                "Error at clk #%0d [num = 0x%h, sel = 0b%b] real = 0x%h, expected = 0x%h",
                clk_cnt, num, sel, pp, expected
            );
            error_cnt += 1;
            stobe();
        end
    endtask

    //====================================================================
    // Testbench running
    //====================================================================

    initial begin
        reset();
        for (int i = 0; i < TEST_NUM; ++i) begin
            prepare();
            drive  ();
            @(posedge clk);
            check  ();
            delay  (1, 10);
        end
        if (error_cnt) $display("FAILED");
        else           $display("PASSED");
        $finish();
    end

endmodule