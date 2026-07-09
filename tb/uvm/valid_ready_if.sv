interface valid_ready_if #(
    valid_ready_pkg::valid_ready_params_s PARAMS = valid_ready_pkg::DEFAULT_PARAMS
)(
    input logic clk,
    input logic rstn
);

    //--------------------------------------------------------------------
    // Ports
    //--------------------------------------------------------------------

    logic ready;
    logic valid;
    logic [PARAMS.data_width - 1:0] data [0:PARAMS.data_num - 1];

    //--------------------------------------------------------------------
    // Modports
    //--------------------------------------------------------------------

    modport master(
        input  clk,
        input  rstn,

        input  ready,
        output valid,
        output data,

        import is_handshake
    );

    modport slave(
        input  clk,
        input  rstn,

        input  valid,
        input  data,
        output ready,

        import is_handshake
    );

    //--------------------------------------------------------------------
    // Methods
    //--------------------------------------------------------------------

    extern function bit is_handshake();

    //--------------------------------------------------------------------
    // Assertions/Coverage
    //--------------------------------------------------------------------

    `include "valid_ready_sva.sv"
    `include "valid_ready_cov.sv"

endinterface: valid_ready_if


function bit valid_ready_if::is_handshake();
    return ready && valid;
endfunction: is_handshake
