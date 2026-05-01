class slave_monitor;    

    //=============================================================================
    // Required external connection
    //=============================================================================

    virtual mul_intf.slave intf;
    mailbox#(packet#(16))  slave_mbx; 
    
    //=============================================================================
    // Functions
    //=============================================================================

    virtual function void configure(test_config cfg);
        intf      = cfg.intf;
        slave_mbx = cfg.slave_mbx;
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
            @(posedge intf.clk)
            if (intf.down_ready && intf.down_vld) begin
                pkt = new();
                pkt.data = intf.res;
                slave_mbx.put(pkt);
            end
        end
    endtask

endclass
