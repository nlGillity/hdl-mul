class test_overloaded extends test;

    //=============================================================================
    // Configuration
    //============================================================================= 

    virtual function int config_gen();
        configs.name = "Test (Overloaded)";
        configs.description = "A scenario in which there are intensive requests\n \
from the master and intensive repsonses from the slave.";

        return configs.randomize() with {
            master_driver_min_delay == 1;
            master_driver_max_delay == 3;

            slave_driver_min_delay  == 1;
            slave_driver_max_delay  == 3;
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