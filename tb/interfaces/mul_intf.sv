interface mul_intf #(
    parameter int DATA_WIDTH = 8
)(
    input  logic clk,
    input  logic rstn,
);

    input  logic                      up_vld,
    output logic                      up_ready,
    input  logic [  DATA_WIDTH - 1:0] a,
    input  logic [  DATA_WIDTH - 1:0] b,

    output logic                      down_vld,
    input  logic                      down_ready,
    output logic [2*DATA_WIDTH - 1:0] res

    function bit handshake();
        return ready && valid;
    endfunction

    modport master (
        input  up_vld,
        output up_ready,
        input  a,
        input  b
    );

    modport slave (
        output down_vld,
        input  down_ready,
        output res
    );

endinterface