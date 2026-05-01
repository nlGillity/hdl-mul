class test_overflow extends test;

    //=============================================================================
    // Configuration
    //============================================================================= 

    virtual function int config_gen();
        configs.name        = "Test (Overflow)";
        configs.description = "Scenario in which requests come much less\nfreqenlty than the credit signal.";

        return configs.randomize() with {
            master_driver_min_delay == credit_num;
            master_driver_max_delay == 10 * credit_num;

            slave_driver_min_delay  == 0;
            slave_driver_max_delay  == 1;
        };
    endfunction

    //=============================================================================
    // Other
    //============================================================================= 

    function new(
        virtual valid_ready_intf  mf,
        virtual valid_credit_intf sf
    );
        super.new(mf, sf);
    endfunction

endclass
