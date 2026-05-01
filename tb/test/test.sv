class test;

    rand test_config configs;
    env              env_obj;

    //=============================================================================
    // Required external connection
    //=============================================================================

    virtual master_intf.master master_intf;
    virtual master_intf.slave  slave_intf;

    mailbox#(packet#( 8)) gen2drv;        
    mailbox#(packet#(16)) master_mbx;
    mailbox#(packet#(16)) slave_mbx;
    
    //=============================================================================
    // Functions
    //============================================================================= 

    function new (
        virtual mul_intf intf
    );
        this.master_intf = intf.master;
        this.slave_intf  = intf.slave;

        configs    = new();
        env_obj    = new();
        gen2drv    = new();
        master_mbx = new();
        slave_mbx  = new();

        configure();
    endfunction

    virtual function void configure();
        if ( config_gen() == 0 ) begin
            $error($time(), " Failed to generate test configs.");
            $finish();
        end else begin
            configs.master_intf = master_intf;
            configs.slave_intf  = slave_intf;

            configs.gen2drv     = gen2drv;
            configs.master_mbx  = master_mbx;
            configs.slave_mbx   = slave_mbx;

            env_obj.configure(configs);
        end
    endfunction

    virtual function int config_gen();
        return configs.randomize();
    endfunction

    //------------------------------------------------------------------------------

    virtual function void print_info();
        $display("\n=====================================================");
        configs.print_general();
        $display("------------------ Configurations -------------------");
        configs.print_randomized();
    endfunction

    virtual function void print_sim();
        $display("-------------------- Simulation ---------------------");
        $display("Simulating...");
    endfunction

    virtual function void print_result();
        $display("---------------------- Result -----------------------");
    endfunction

    virtual function void print_end();
        $display("=====================================================");
    endfunction

    //=============================================================================
    // Tasks
    //============================================================================= 

    virtual task run();
        print_info();
        print_sim();

        passed = 0;
        fork
            env_obj.run();
            timeout();
        join_any
        disable fork;     

        print_end();   
    endtask

    virtual task timeout();
        repeat (configs.timeout) @(posedge master_intf.clk);
        $display("Timeout!");
    endtask

endclass
