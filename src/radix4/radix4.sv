module radix4 #(
    parameter DATA_WIDTH = 32   
)(
    input  logic [DATA_WIDTH - 1:0] num,
    input  logic [             2:0] sel,
    output logic [DATA_WIDTH + 1:0] pp
);

    wire [DATA_WIDTH + 1:0] zero = 'b0;            
    wire [DATA_WIDTH + 1:0] se   = { {2{num[DATA_WIDTH - 1]}}, num }; // sign extanded
    wire [DATA_WIDTH + 1:0] x2   = se << 1;                           // 2 * num
    wire [DATA_WIDTH + 1:0] neg  = ~se + 1'b1;                        // -num (two's compliment)
    wire [DATA_WIDTH + 1:0] nx2  = neg << 1;                          // -2 * num

    always_comb begin
        case (sel)
            3'b000  : pp = zero;
            3'b001  : pp = se;
            3'b010  : pp = se;
            3'b011  : pp = x2;
            3'b100  : pp = nx2;
            3'b101  : pp = neg;
            3'b110  : pp = neg;
            3'b111  : pp = zero;
            default : pp = zero;
        endcase
    end

endmodule