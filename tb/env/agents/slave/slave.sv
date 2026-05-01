class slave;

    slave_driver  driver;
    slave_monitor monitor;

    //=============================================================================
    // Functions
    //=============================================================================

    function new();
        driver   = new();
        monitor  = new();
    endfunction

    virtual function void configure(test_config cfg);
        driver .configure(cfg);
        monitor.configure(cfg);
    endfunction

    //=============================================================================
    // Tasks
    //=============================================================================

    virtual task run();
        credit_storage = 0;
        fork
            driver .run();
            monitor.run();
        join
    endtask

endclass
