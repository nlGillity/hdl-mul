`timescale 10ns/100ps;

module mul_tb;

    localparam int DATA_WIDTH     = 8;
    localparam int CLOCK_PERIOD   = 10;
    localparam int RESET_DURATION = 20;
    localparam int TEST_NUM       = 500;

    logic clk;
    logic rstn;
    int   clk_cnt;

    logic error_stob;
    int   error_cnt;
    
    //====================================================================
    // Wiring with DUT and check variables
    //====================================================================

    logic                      up_vld,     next_up_vld;
    logic                      up_ready;
    logic [  DATA_WIDTH - 1:0] a,          next_a;
    logic [  DATA_WIDTH - 1:0] b,          next_b;

    logic                      down_vld;
    logic                      down_ready, next_down_ready;
    logic [2*DATA_WIDTH - 1:0] res;

    int signed expected;

    //====================================================================
    // Device Under Test
    //====================================================================

    mul DUT (
        .clk        ( clk        ),
        .rstn       ( rstn       ),

        .up_vld     ( up_vld     ),
        .up_ready   ( up_ready   ),
        .a          ( a          ),
        .b          ( b          ),

        .down_vld   ( down_vld   ),
        .down_ready ( down_ready ),
        .res        ( res        )
    );

    //====================================================================
    // Genetrial proccesses/tasks
    //====================================================================

    initial begin
        $dumpfile("sim.vcd");
        $dumpvars(0, mul_tb);
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
        rstn       <= 1'b0;
        a          <= '0;
        b          <= '0;
        up_vld     <= 1'b0;
        down_ready <= 1'b0;
        error_stob <= 1'b0;
        repeat (RESET_DURATION) @(posedge clk);
        rstn      <= 1'b1;
    endtask

    //====================================================================
    // Funbctions
    //====================================================================

    // DUT stimulation functions
    //--------------------------------------------------------------------

    function void prepare();
        next_a          = $urandom_range(10, 255);
        next_b          = $urandom_range(10, 255);
        next_up_vld     = $urandom_range(1, 0);
        next_down_ready = $urandom_range(1, 0);
        expected        = signed'(next_a) * signed'(next_b);
    endfunction

    task drive();
        a          <= next_a;
        b          <= next_b;
        up_vld     <= next_up_vld;
        down_ready <= next_down_ready;
        @(posedge clk);
        a          <= '0;
        b          <= '0;
        up_vld     <= '0;
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
        if (signed'(res) !== expected) begin
            $display(
                "Error at clk #%0d [a = %0d, b = %0d] real = %0d, expected = %0d",
                clk_cnt, a, b, signed'(res), expected
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
            // check  ();
        end
        if (error_cnt) $display("FAILED");
        else           $display("PASSED");
        $finish();
    end

endmodule