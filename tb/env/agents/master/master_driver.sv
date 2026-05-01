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
        intf      = cfg.master_intf;
        min_delay = cfg.master_driver_min_delay;
        max_delay = cfg.master_driver_max_delay;
        gen2drv   = cfg.gen2drv;
    endfunction

    //=============================================================================
    // Tasks
    //=============================================================================

    virtual task run();
        forever begin
            wait(intf.rst_n);
            fork
                forever begin
                    delay();
                    drive();
                    wait_response();
                    reset();
                end
            join_none
            wait(!intf.rst_n);
            disable fork;
            reset();
        end
    endtask

    virtual task drive();
        packet pkt;
        pkt = new();
        gen2drv.get(pkt);
        intf.valid <= 1'b1;
        intf.data  <= pkt.data;
    endtask

    virtual task wait_response();
        do    @(posedge intf.clk);
        while (!intf.ready);
    endtask

    virtual task reset();
        intf.valid <= 1'b0;
        intf.data  <= 1'b0;
    endtask

    virtual task delay();
        int delay = $urandom_range(min_delay, max_delay);
        repeat (delay) @(posedge intf.clk);
    endtask

endclass
