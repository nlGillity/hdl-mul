class test_busy_slave extends test;

    //=============================================================================
    // Configuration
    //============================================================================= 

    virtual function int config_gen();
        $display("Extended config_gen");
        configs.name = "Test (Busy Slave)";
        configs.description = "A scenario in which the master's request rate\n \
is an order of magnitude higher than\n \
the slave's response rate.";

        return configs.randomize() with {
            master_driver_min_delay == 1;
            master_driver_max_delay == 5;

            slave_driver_min_delay  == 10;
            slave_driver_max_delay  == 15;
        } ;
    endfunction

    //=============================================================================
    // Other
    //=============================================================================

    function new(
        virtual mul_intf intf
    );
        super.new(intf);
        $display("Extended");
    endfunction

endclass