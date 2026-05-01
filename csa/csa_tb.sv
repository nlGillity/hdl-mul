module csa_tb;

    localparam int DATA_WIDTH     = 8;
    localparam int CLOCK_PERIOD   = 10;
    localparam int RESET_DURATION = 20;
    localparam int TEST_NUM       = 200;

    logic clk;
    int   clk_cnt;

    logic error_stob;
    int   error_cnt;
    
    //====================================================================
    // Wiring with DUT and check variables
    //====================================================================

    logic [DATA_WIDTH - 1:0] a,   next_a;
    logic [DATA_WIDTH - 1:0] b,   next_b;
    logic [DATA_WIDTH - 1:0] cin, next_cin;

    logic [DATA_WIDTH - 1:0] sum;
    logic [DATA_WIDTH - 1:0] cout;

    int real_sum;
    int expected_sum;

    //====================================================================
    // Device Under Test
    //====================================================================

    csa #(DATA_WIDTH) DUT (
        .a    ( a    ),
        .b    ( b    ),
        .cin  ( cin  ),
        .sum  ( sum  ),
        .cout ( cout )
    );

    //====================================================================
    // Genetrial proccesses/tasks
    //====================================================================

    initial begin
        $dumpfile("sim.vcd");
        $dumpvars(0, csa_tb);
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
        a          <= '0;
        b          <= '0;
        cin        <= '0;
        error_stob <= 1'b0;
        repeat (RESET_DURATION) @(posedge clk);
    endtask

    //====================================================================
    // Funbctions
    //====================================================================

    // DUT stimulation functions
    //--------------------------------------------------------------------

    function void prepare();
        next_a       = $urandom_range(2 ** DATA_WIDTH - 1);
        next_b       = $urandom_range(2 ** DATA_WIDTH - 1);
        next_cin     = $urandom_range(2 ** DATA_WIDTH - 1);
        expected_sum = next_a + next_b + next_cin;
    endfunction

    task drive();
        a   <= next_a;
        b   <= next_b;
        cin <= next_cin;
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
        real_sum = sum + (cout << 1); 
        if (real_sum !== expected_sum) begin
            $display(
                "Error at clk #%0d [sum = 0x%h, cout = 0x%h] real = 0x%h, expected = 0x%h",
                clk_cnt, sum, cout, real_sum, expected_sum
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