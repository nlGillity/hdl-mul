//=======================================================================
// Valid-ready
//=======================================================================

down_vld_stability_a: assert property (
    @(posedge clk) disable iff (!rstn)
    down_vld && !down_ready |=> $stable(down_vld) until_with down_ready
) else $error (
    "ERROR: down_vld does not wait for down_ready."
);

down_handshake_a: assert property (
    @(posedge clk) disable iff (!rstn)
    down_vld && down_ready && valid_ff[LAST - 1] |=> res == $past(sum)
) else $error (
    "ERROR: invalid down handshake."
);

up_ready_a: assert property (
    @(posedge clk) disable iff (!rstn)
    !valid_ff[0] |-> up_ready
) else $error (
    "ERROR: module does not accept new data when first stage is free."
);

//=======================================================================
// Pipeline
//=======================================================================

stall_a: assert property (
    @(posedge clk) disable iff (!rstn)
    !down_ready && (&valid_ff) |-> !up_ready until down_ready
) else $error (
    "ERROR: up_ready does not wait down_ready when pipeine stalls."
);