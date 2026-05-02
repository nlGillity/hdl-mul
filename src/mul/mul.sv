`timescale 10ns/100ps

module mul #(
    localparam int DATA_WIDTH = 8
)(
    input  logic                      clk,
    input  logic                      rstn,

    input  logic                      up_vld,
    output logic                      up_ready,
    input  logic [  DATA_WIDTH - 1:0] a,
    input  logic [  DATA_WIDTH - 1:0] b,

    output logic                      down_vld,
    input  logic                      down_ready,
    output logic [2*DATA_WIDTH - 1:0] res
);

    //=======================================================================
    // Flow control
    //=======================================================================

    localparam int LAST = DATA_WIDTH / 2 - 1; 

    wire  [DATA_WIDTH / 2 - 1:0] flow_en;
    logic [DATA_WIDTH / 2 - 1:0] valid_ff;

    always_ff @(posedge clk or negedge rstn) begin
        if (~rstn) valid_ff <= '0;
        else begin
            for (int i = 1; i <= LAST; ++i) begin
                if (flow_en[i]) 
                    valid_ff[i] <= valid_ff[i - 1];
            end
            if (flow_en[0]) 
                valid_ff[0] <= up_vld; 
        end
    end


    generate
        assign flow_en[LAST] = down_ready | ~valid_ff[LAST];
        for (genvar i = 0; i < LAST; ++i)
            assign flow_en[i] = flow_en[i + 1] | ~valid_ff[i];
    endgenerate

    //=======================================================================
    // Valid-ready
    //=======================================================================

    assign up_ready = flow_en[0];
    assign down_vld = valid_ff[LAST];

    //=======================================================================
    // Booth recoding stage
    //=======================================================================

    wire [DATA_WIDTH + 1:0] pp  [0:DATA_WIDTH / 2 - 1];
    wire [             2:0] sel [0:DATA_WIDTH / 2 - 1];

    generate
        for (genvar i = 0; i < DATA_WIDTH / 2; i++) begin
            if (i == 0) assign sel[i] = { b[1:0], 1'b0 };
            else        assign sel[i] = b[(2*i + 1) : (2*i - 1)];
        end
    endgenerate

    generate
        for (genvar i = 0; i < DATA_WIDTH / 2; i += 1) begin
            radix4 #(
                .DATA_WIDTH (DATA_WIDTH)
            ) booth_recoding (
                .num ( a       ),
                .sel ( sel [i] ),
                .pp  ( pp  [i] )
            );
        end
    endgenerate

    // Buffering to next stage
    //------------------------------------------------------------------------

    logic [DATA_WIDTH + 1:0] pp_ff [0:DATA_WIDTH / 2 - 1];

    always_ff @(posedge clk) begin
        if (flow_en[0] & up_vld)
            for (int i = 0; i < DATA_WIDTH / 2; ++i)
                pp_ff[i] <= pp[i];
    end

    //=======================================================================
    // Wallace tree stage
    //=======================================================================

    // Stage 1
    //------------------------------------------------------------------------

    wire [15:0] pp0_stage1;
    wire [12:0] pp1_stage1;

    assign pp0_stage1[1:0] = pp_ff[0][1:0];

    csa #(
        .DATA_WIDTH (2)
    ) ha1_stage1 (
        .a    ( pp_ff   [0][3:2] ),
        .b    ( pp_ff   [1][1:0] ),
        .cin  ( 2'b0             ),

        .sum  ( pp0_stage1 [3:2] ),
        .cout ( pp1_stage1 [1:0] ) 
    );

    csa #(
        .DATA_WIDTH (12)
    ) fa1_stage1 (
        .a    ( { {6{pp_ff[0][9]}}, pp_ff[0][9:4] } ),
        .b    ( { {4{pp_ff[1][9]}}, pp_ff[1][9:2] } ),
        .cin  ( { {2{pp_ff[2][9]}}, pp_ff[2]      } ),

        .sum  ( pp0_stage1 [15:4] ),
        .cout ( pp1_stage1 [12:2] ) 
    );

    // Buffering to next stage
    //------------------------------------------------------------------------

    logic [15:0] pp0_stage1_ff;
    logic [12:0] pp1_stage1_ff;
    logic [ 9:0] pp3_ff;

    always_ff @(posedge clk) begin
        if (flow_en[1] & valid_ff[0]) begin
            pp0_stage1_ff <= pp0_stage1;
            pp1_stage1_ff <= pp1_stage1;
            pp3_ff        <= pp_ff[3];
        end
    end

    // Stage 2
    //------------------------------------------------------------------------

    wire [15:0] pp0_stage2;
    wire [11:0] pp1_stage2;

    assign pp0_stage2[2:0] = pp0_stage1_ff[2:0];

    csa #(
        .DATA_WIDTH (3)
    ) ha1_stage2 (
        .a    ( pp0_stage1_ff [5:3] ),
        .b    ( pp1_stage1_ff [2:0] ),
        .cin  ( 3'b0                ),

        .sum  ( pp0_stage2    [5:3] ),
        .cout ( pp1_stage2    [2:0] ) 
    );

    csa #(
        .DATA_WIDTH (10)
    ) fa1_stage2 (
        .a    ( pp0_stage1_ff [15:6] ),
        .b    ( pp1_stage1_ff [12:3] ),
        .cin  ( pp3_ff               ),

        .sum  ( pp0_stage2    [15:6] ),
        .cout ( pp1_stage2    [11:3] ) 
    );

    // Buffering to next stage
    //------------------------------------------------------------------------

    logic [15:0] pp0_stage2_ff;
    logic [11:0] pp1_stage2_ff;

    always_ff @(posedge clk) begin
        if (flow_en[2] & valid_ff[1]) begin
            pp0_stage2_ff <= pp0_stage2;
            pp1_stage2_ff <= pp1_stage2;
        end
    end

    //=======================================================================
    // Final sum stage
    //=======================================================================

    wire [2*DATA_WIDTH - 1:0] sum;
    assign sum = { pp0_stage2_ff[15:4] + pp1_stage2_ff, pp0_stage2_ff[3:0] };

    // Buffering to output
    //------------------------------------------------------------------------

    always_ff @(posedge clk) begin
        if (flow_en[LAST] & valid_ff[LAST - 1]) res <= sum;
    end

    //=======================================================================
    // SVA and Coverage
    //=======================================================================

    `include "mul_sva.sv"
    `include "mul_cov.sv"

endmodule