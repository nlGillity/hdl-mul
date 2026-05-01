always_ff @(posedge clk) begin
    if (rstn) begin
    
        // Valid-ready check
        if (down_vld && ~down_ready)
            assert(down_vld) else $error(
                "Error: down_vld does not retain its value."
            );
                
        // Backpressure check
        if (~down_ready && (&valid_ff))
            assert(~up_ready) else $error(
                "Error: down_vld does not retain its value."
            );

    end
end