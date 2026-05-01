class test_normal extends test;

    //=============================================================================
    // Configuration
    //============================================================================= 

    virtual function int config_gen();
        configs.name        = "Test (Normal)";
        configs.description = "The frequency of reqesting and credit reflling\nis the same.";

        return configs.randomize() with {
            master_driver_min_delay == 0;
            master_driver_max_delay == 5*credit_num;

            slave_driver_min_delay  == 2;
            slave_driver_max_delay  == 2;
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
