class test_intensive extends test;

    //=============================================================================
    // Configuration
    //============================================================================= 

    virtual function int config_gen();
        configs.name        = "Test (Intensive)";
        configs.description = "Scenario of intensive requesting and refilling.";

        return configs.randomize() with {
            master_driver_min_delay == 1;
            master_driver_max_delay == credit_num;

            slave_driver_min_delay  == 0;
            slave_driver_max_delay  == credit_num;
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
