class test_exhaustion extends test;

    //=============================================================================
    // Configuration
    //============================================================================= 

    virtual function int config_gen();
        configs.name        = "Test (Exhaustion)";
        configs.description = "Scenario of spending all credits without\nrefilling.";

        configs.packet_num      = 10 * configs.credit_num;
        configs.timeout         = 100;
        return configs.randomize() with {
            master_driver_min_delay == 0;
            master_driver_max_delay == 0;

            slave_driver_min_delay   > timeout;
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
