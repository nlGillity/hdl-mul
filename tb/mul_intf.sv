interface mul_intf #(
    parameter int DATA_WIDTH = 8
)(
    input  logic clk,
    input  logic rstn
);

    logic                      up_vld;
    logic                      up_ready;
    logic [  DATA_WIDTH - 1:0] a;
    logic [  DATA_WIDTH - 1:0] b;

    logic                      down_vld;
    logic                      down_ready;
    logic [2*DATA_WIDTH - 1:0] res;

    modport master (
        input  clk,
        input  rstn,
        output up_vld,
        input  up_ready,
        output a,
        output b
    );

    modport slave (
        input  clk,
        input  rstn,
        input  down_vld,
        output down_ready,
        input  res
    );

endinterface