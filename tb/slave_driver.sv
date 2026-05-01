class slave_driver;

    int min_delay;
    int max_delay;

    //=============================================================================
    // Required external connection
    //============================================================================= 

    virtual mul_intf.slave intf;

    //=============================================================================
    // Functions
    //============================================================================= 
    
    virtual function void configure(test_config cfg);
        intf      = cfg.intf;
        min_delay = cfg.slave_driver_min_delay;
        max_delay = cfg.slave_driver_max_delay;
    endfunction

    //=============================================================================
    // Tasks
    //============================================================================= 

    virtual task run();
        forever begin
            wait(intf.rstn);
            fork
                forever drive();
            join_none
            wait(!intf.rstn);
            disable fork;
            reset();
        end
    endtask

    virtual task drive();
        intf.down_ready <= 1'b1;
        delay();
        intf.down_ready <= 1'b0;
        delay();
    endtask

    virtual task delay();
        int delay = $urandom_range(min_delay, max_delay);
        repeat (delay) @(posedge intf.clk);
    endtask

    virtual task reset();
        intf.down_ready <= 1'b0;
    endtask

endclass
