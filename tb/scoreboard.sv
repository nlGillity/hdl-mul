class scoreboard;

    int packet_num;

    //=============================================================================
    // Required external connection
    //=============================================================================

    mailbox#(packet#(16)) master_mbx;
    mailbox#(packet#(16)) slave_mbx;

    //=============================================================================
    // Functions
    //=============================================================================

    virtual function void configure(test_config cfg);
        packet_num = cfg.packet_num;
        master_mbx = cfg.master_mbx;
        slave_mbx  = cfg.slave_mbx;
    endfunction

    //-----------------------------------------------------------------------------

    virtual function void check (
        packet#(16) in_pkt,
        packet#(16) out_pkt
    );
        $display("expected = %d; real = %d", in_pkt.data, out_pkt.data);
        assert (in_pkt.data == out_pkt.data) else begin
            $error(
                "[%0d expected %0d; real %0d", 
                $time(), in_pkt.data, out_pkt.data
            );
        end
    endfunction

    //=============================================================================
    // Tasks
    //=============================================================================

    virtual task run();
        packet#(16) in_pkt;
        packet#(16) out_pkt;
        repeat (packet_num) begin
            master_mbx.get(in_pkt);
            slave_mbx .get(out_pkt);
            check(in_pkt, out_pkt);
        end
    endtask

endclass
