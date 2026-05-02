class test_free_fall extends test;

    //=============================================================================
    // Configuration
    //============================================================================= 

    virtual function int config_gen();
        configs.name = "Test (Free fall)";
        configs.description = "A scenario in which data passes through\n \
the pipeline without stalls.";

        return configs.randomize() with {
            master_driver_min_delay == 0;
            master_driver_max_delay == 0;

            slave_driver_min_delay  == 0;
            slave_driver_max_delay  == 0;
        };
    endfunction

    //=============================================================================
    // Other
    //=============================================================================

    function new(
        virtual mul_intf intf
    );
        super.new(intf);
    endfunction

endclass