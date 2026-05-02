//=======================================================================
// Valid_ready
//=======================================================================

up_handshake_c: cover property (
    @(posedge clk) disable iff (!rstn)
    up_ready && up_vld
);

down_handshake_c: cover property (
    @(posedge clk) disable iff (!rstn)
    down_ready && down_vld
);

down_wait_c: cover property (
    @(posedge clk) disable iff (!rstn)
    down_vld && !down_ready |=> $stable(down_vld) until down_ready
);

up_wait_c: cover property (
    @(posedge clk) disable iff (!rstn)
    up_vld && !up_ready |=> $stable(up_vld) until up_ready
);

//=======================================================================
// Combinations of input numbers
//=======================================================================

all_pos_c: cover property (
    @(posedge clk) disable iff (!rstn)
    up_ready && up_vld |-> (a > 0) && (b > 0)
);

all_neg_c: cover property (
    @(posedge clk) disable iff (!rstn)
    up_ready && up_vld |-> (byte'(a) < 0) && (byte'(b) < 0)
);

some_neg_c: cover property (
    @(posedge clk) disable iff (!rstn)
    up_ready && up_vld |-> (byte'(a) < 0) || (byte'(b) < 0)
);

some_zero_c: cover property (
    @(posedge clk) disable iff (!rstn)
    up_ready && up_vld |-> (a == 0) || (b == 0)
);

//=======================================================================
// Pipeline
//=======================================================================

saturation_c: cover property (
    @(posedge clk) disable iff (!rstn)
    up_vld && up_ready && !down_vld |=> !up_ready until down_vld
);