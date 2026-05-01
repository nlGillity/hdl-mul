`timescale 1ns/1ps

module tb;

    logic clk;
    logic rstn; 

    import test_pkg::*;

    //=============================================================================
    // Parameters
    //=============================================================================

    localparam int TEST_NUM       = 5;
    localparam int CLOCK_PERIOD   = 10;
    localparam int RESET_DURATION = 20;

    //=============================================================================
    // DUT
    //=============================================================================

    mul_intf #(8) intf (clk, rstn);

    mul DUT (
        .clk        ( clk                    ),
        .rstn       ( rstn                   ),

        .up_vld     ( intf.slave.up_vld      ),
        .up_ready   ( intf.slave.up_ready    ),
        .a          ( intf.slave.a           ),
        .b          ( intf.slave.b           ),

        .down_vld   ( intf.master.down_vld   ),
        .down_ready ( intf.master.down_ready ),
        .res        ( intf.master.res        )
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
        intf.up_valid   <= 1'b0;
        intf.a          <= 1'b0;
        intf.b          <= 1'b0;
        intf.down_ready <= 1'b0;
        repeat (RESET_DURATION) @(posedge clk);
        rstn            <= 1'b1;
    endtask

    //=============================================================================
    // Test Scenarios
    //=============================================================================

    // int  passed_num;
    // test test_scenarios [$];

    // test_normal      scenario_normal      = new(intf);
    // test_exhaustion  scenario_exhaustion  = new(intf);
    // test_overwhelmed scenario_overwhelmed = new(intf);
    // test_overflow    scenario_overflow    = new(intf);
    // test_intensive   scenario_intensive   = new(intf);

    //-----------------------------------------------------------------------------

    // function void tests_randomize(output test tests []);
    //     tests = {
    //         scenario_normal,
    //         scenario_exhaustion,
    //         scenario_overwhelmed,
    //         scenario_overflow,
    //         scenario_intensive
    //     };
    //     test_scenarios.shuffle();
    // endfunction

    // task tests_run(test tests []);
    //     foreach (tests[i]) begin
    //         reset();
    //         repeat (2) @(posedge clk);
    //         tests[i].run();
    //         passed_num += int'(tests[i].passed);
    //     end
    // endtask

    // //=============================================================================
    // // Running Tests
    // //=============================================================================

    // initial begin
    //     tests_randomize(test_scenarios);
    //     tests_run(test_scenarios);
    //     $finish();
    // end

endmodule
