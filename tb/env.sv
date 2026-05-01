class env;

    master     master_obj;
    slave      slave_obj;
    scoreboard scoreboard_obj;

    //=============================================================================
    // Functions
    //=============================================================================

    function new();
        master_obj     = new();
        slave_obj      = new();
        scoreboard_obj = new();
    endfunction

    //-----------------------------------------------------------------------------

    virtual function void configure(test_config cfg);
        master_obj    .configure(cfg);
        slave_obj     .configure(cfg);
        scoreboard_obj.configure(cfg);
    endfunction 

    //=============================================================================
    // Tasks
    //=============================================================================
    virtual task run();
        fork
            master_obj    .run();
            slave_obj     .run();
            scoreboard_obj.run();
        join_any
        disable fork;
    endtask

endclass
