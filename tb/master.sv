class master;

    master_driver    driver;
    master_generator generator;
    master_monitor   monitor;

    //=============================================================================
    // Functions
    //=============================================================================

    function new();
        driver    = new();
        generator = new();
        monitor   = new();
    endfunction

    virtual function void configure(test_config cfg);
        driver   .configure(cfg);
        generator.configure(cfg);
        monitor  .configure(cfg);
    endfunction

    //=============================================================================
    // Tasks
    //=============================================================================

    virtual task run();
        fork
            driver   .run();
            monitor  .run();
            generator.run();
        join
    endtask

endclass
