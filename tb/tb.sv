`timescale 1ns/1ps

module tb;

    logic clk;
    logic rstn; 

    import test_pkg::*;

    //=============================================================================
    // Parameters
    //=============================================================================

    localparam int TEST_NUM       = 4;
    localparam int CLOCK_PERIOD   = 10;
    localparam int RESET_DURATION = 20;

    //=============================================================================
    // DUT
    //=============================================================================

    mul_intf #(8) intf (clk, rstn);

    mul DUT (
        .clk        ( clk              ),
        .rstn       ( rstn             ),

        .up_vld     ( intf.up_vld      ),
        .up_ready   ( intf.up_ready    ),
        .a          ( intf.a           ),
        .b          ( intf.b           ),

        .down_vld   ( intf.down_vld    ),
        .down_ready ( intf.down_ready  ),
        .res        ( intf.res         )
    );

    //=============================================================================
    // General Tasks
    //=============================================================================

    // Clocking
    initial begin
        clk <= 0; 
        forever begin
            #(CLOCK_PERIOD / 2) clk <= ~clk;
        end
    end

    // Reseting
    task reset();
        rstn            <= 1'b0;
        intf.up_vld     <= 1'b0;
        intf.a          <= 1'b0;
        intf.b          <= 1'b0;
        intf.down_ready <= 1'b0;
        repeat (RESET_DURATION) @(posedge clk);
        rstn            <= 1'b1;
        intf.down_ready <= 1'b1;
    endtask

    //=============================================================================
    // Test Scenarios
    //=============================================================================

    // int  passed_num;
    test test_scenarios [$];

    test_busy_slave scenario_busy_slave = new(intf);
    test_overloaded scenario_overloaded = new(intf);
    test_free_fall  scenario_free_fall  = new(intf);
    test_sparse     scenario_sparse     = new(intf);

    //-----------------------------------------------------------------------------

    function void tests_randomize(output test tests []);
        tests = {
            scenario_busy_slave,
            scenario_overloaded,
            scenario_free_fall,
            scenario_sparse
        };
        foreach (tests[i]) tests[i].configure();
        tests.shuffle();
    endfunction

    task tests_run(test tests []);
        foreach (tests[i]) begin
            reset();
            repeat (2) @(posedge clk);
            tests[i].run();
        end
    endtask

    //=============================================================================
    // Running Tests
    //=============================================================================

    initial begin
        reset();
        tests_randomize(test_scenarios);
        tests_run(test_scenarios);
        $finish();
    end

endmodule
