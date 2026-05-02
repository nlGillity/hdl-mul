class master_monitor;

    //=============================================================================
    // Required external connection
    //=============================================================================
    
    virtual mul_intf.master intf;
    mailbox#(packet#(16))   master_mbx;

    //=============================================================================
    // Functions
    //=============================================================================

    virtual function void configure(test_config cfg);
        intf       = cfg.intf;
        master_mbx = cfg.master_mbx;
    endfunction

    //=============================================================================
    // Tasks
    //=============================================================================

    virtual task run();
        forever begin
            wait(intf.rstn);
            fork
                monitor();
            join_none
            wait(!intf.rstn);
            disable fork;
        end
    endtask;

    virtual task monitor();
        packet#(16) pkt;
        forever begin
            @(posedge intf.clk);
            if (intf.up_vld && intf.up_ready) begin
                pkt = new();
                pkt.data = 16'(byte'(intf.a) * byte'(intf.b));
                master_mbx.put(pkt);
            end
        end
    endtask

endclass
