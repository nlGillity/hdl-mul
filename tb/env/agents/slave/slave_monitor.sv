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
        intf      = cfg.slave_intf.slave;
        slave_mbx = cfg.slave_mbx;
    endfunction

    //=============================================================================
    // Tasks
    //=============================================================================

    virtual task run();
        forever begin
            wait(intf.rst_n);
            fork
                monitor();
            join_none
            wait(!intf.rst_n);
            disable fork;
        end
    endtask;

    virtual task monitor();
        packet#(16) pkt;
        pkt = new();
        forever begin
            @(posedge intf.clk)
            if (intf.handshake()) begin
                pkt.data = intf.data;
                slave_mbx.put(pkt);
            end
        end
    endtask

endclass
