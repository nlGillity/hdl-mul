class scoreboard;

    int packet_num;

    //=============================================================================
    // Required external connection
    //=============================================================================

    const int width = 16;

    mailbox#(packet#(width)) master_mbx;
    mailbox#(packet#(width)) slave_mbx;

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
        packet#(width) in_pkt,
        packet#(width) out_pkt
    );
        assert (in_pkt.data == out_pkt.data) else begin
            $error(
                "[%0d Difference #%0d] expected %0d; real %0d", 
                $time(), score + 1, in_pkt.data, out_pkt.data
            );
        end
    endfunction

    //=============================================================================
    // Tasks
    //=============================================================================

    virtual task run();
        packet#(width) in_pkt;
        packet#(width) out_pkt;
        repeat (packet_num) begin
            master_mbx.get(in_pkt);
            slave_mbx .get(out_pkt);
            check(in_pkt, out_pkt);
        end
    endtask

endclass
