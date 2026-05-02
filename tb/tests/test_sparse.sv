class test_sparse extends test;

    //=============================================================================
    // Configuration
    //============================================================================= 

    virtual function int config_gen();
        configs.name = "Test (Sparse)";
        configs.description = "A scenario in which master's requests are rare,\n \
and the slave is always ready to receive data.";

        return configs.randomize() with {
            master_driver_min_delay == 1;
            master_driver_max_delay == 10;

            slave_driver_min_delay  == 1;
            slave_driver_max_delay  == 1;
        } ;
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