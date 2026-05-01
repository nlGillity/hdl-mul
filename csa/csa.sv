module csa #(
    parameter DATA_WIDTH = 32
)(
    input  logic [DATA_WIDTH - 1:0] a,
    input  logic [DATA_WIDTH - 1:0] b,
    input  logic [DATA_WIDTH - 1:0] cin,

    output logic [DATA_WIDTH - 1:0] sum,
    output logic [DATA_WIDTH - 1:0] cout
);

    generate
        for (genvar i = 0; i < DATA_WIDTH; ++i) begin
            assign sum  [i] = a[i] ^ b[i] ^ cin[i];
            assign cout [i] = (a[i] & b[i]) | (a[i] & cin[i]) | (b[i] & cin[i]);
        end
    endgenerate
    
endmodule