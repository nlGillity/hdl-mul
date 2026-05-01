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
        intf       = cfg.master_intf.master;
        master_mbx = cfg.master_mbx;
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
            @(posedge intf.clk);
            if (intf.handshake()) begin
                pkt.data = intf.a * intf.b;
                master_mbx.put(pkt);
            end
        end
    endtask

endclass
