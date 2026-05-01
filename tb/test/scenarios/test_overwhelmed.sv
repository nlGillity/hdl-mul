class test_overwhelmed extends test;

    //=============================================================================
    // Configuration
    //============================================================================= 

    virtual function int config_gen();
        configs.name        = "Test (Overwhelmed)";
        configs.description = "The adapter is overloaded with requests,\ncredits are received rarely.";

        return configs.randomize() with {
            master_driver_min_delay == 0;
            master_driver_max_delay == credit_num;

            slave_driver_min_delay  == 5 * credit_num;
            slave_driver_max_delay  == 10 * credit_num;
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
