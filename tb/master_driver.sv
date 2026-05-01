class master_driver;

    int min_delay;
    int max_delay;

    //=============================================================================
    // Required external connection
    //=============================================================================

    virtual mul_intf.master intf;
    mailbox#(packet#(8))    gen2drv;

    //=============================================================================
    // Functions
    //=============================================================================

    virtual function void configure(test_config cfg);
        intf      = cfg.intf;
        min_delay = cfg.master_driver_min_delay;
        max_delay = cfg.master_driver_max_delay;
        gen2drv   = cfg.gen2drv;
    endfunction

    //=============================================================================
    // Tasks
    //=============================================================================

    virtual task run();
        forever begin
            wait(intf.rstn);
            fork
                forever begin
                    delay();
                    drive();
                    wait_response();
                    reset();
                end
            join_none
            wait(!intf.rstn);
            disable fork;
            reset();
        end
    endtask

    virtual task drive();
        packet#(8) pkt;
        pkt = new();

        intf.up_vld <= 1'b1;
        gen2drv.get(pkt);
        intf.a      <= pkt.data;
        gen2drv.get(pkt);
        intf.b      <= pkt.data;
    endtask

    virtual task wait_response();
        do    @(posedge intf.clk);
        while (!intf.up_ready);
    endtask

    virtual task reset();
        intf.up_vld <= 1'b0;
        intf.a      <= '0;
        intf.b      <= '0;
    endtask

    virtual task delay();
        int delay = $urandom_range(min_delay, max_delay);
        repeat (delay) @(posedge intf.clk);
    endtask

endclass
