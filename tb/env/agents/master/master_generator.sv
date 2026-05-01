class master_generator;

    int gen_num;

    //=============================================================================
    // Required external connection
    //=============================================================================

    mailbox#(packet#(8)) gen2drv;

    //=============================================================================
    // Functions
    //=============================================================================

    virtual function void configure(test_config cfg);
        gen_num = cfg.packet_num;
        gen2drv = cfg.gen2drv;
    endfunction

    //=============================================================================
    // Tasks
    //=============================================================================

    virtual task run();
        repeat (gen_num) gen();
    endtask

    virtual task gen();
        packet pkt;
        pkt = new();
        if ( pkt.randomize() == 0 ) begin
            $error(
                $time(), 
                " Failed to generate a packet."
            );
            $finish();
        end else begin
            gen2drv.put(pkt);
        end
    endtask

endclass
