import uvm_pkg::*;
`include "uvm_macros.svh"
`include "config_macros.svh"

typedef enum bit[1:0] { NONE, SHORT, MEDIUM, LARGE } delay_kind_e;
typedef enum bit[1:0] { ZERO, POS, NEG, SEMI }       data_kind_e;

virtual class base_packet extends uvm_sequence_item;

    rand delay_kind_e delay_kind;
    rand int unsigned delay;

    constraint delay_kind_con {
        (delay_kind == NONE  ) -> delay == 0;
        (delay_kind == SHORT ) -> delay inside { [`SHORT_MIN_DELAY  : `SHORT_MAX_DELAY ] };
        (delay_kind == MEDIUM) -> delay inside { [`MEDIUM_MIN_DELAY : `MEDIUM_MAX_DELAY] };
        (delay_kind == LARGE ) -> delay inside { [`LARGE_MIN_DELAY  : `LARGE_MAX_DELAY ] };
    }

    `uvm_object_utils_begin(base_packet)
        `uvm_field_int(delay_kind, UVM_DEFAULT)
        `uvm_field_int(delay,      UVM_DEFAULT)
    `uvm_object_utils_end

    function new(string name = `BASE_PACKET_NAME);
        super.new(name);
    endfunction

endclass: base_packet


class master_packet #(
    parameter int unsigned DATA_WIDTH = 8
) extends base_packet;

    rand bit                           vld;
    rand bit signed [DATA_WIDTH-1:0]   a;
    rand bit signed [DATA_WIDTH-1:0]   b;
    rand data_kind_e                   data_kind;

    bit                                ready;

    constraint data_kind_con {
        (data_kind == ZERO) -> (a == 0 && b == 0);
        (data_kind == POS ) -> (a  > 0 && b  > 0);
        (data_kind == NEG ) -> (a  < 0 && b  < 0);
        (data_kind == SEMI) -> ((a < 0 && b > 0) || (a > 0 && b < 0));
    }

    `uvm_object_utils_begin(master_packet)
        `uvm_field_int (vld,       UVM_DEFAULT)
        `uvm_field_int (a,         UVM_DEFAULT)
        `uvm_field_int (b,         UVM_DEFAULT)
        `uvm_field_enum(data_kind, UVM_DEFAULT)
        `uvm_field_int (ready,     UVM_DEFAULT | UVM_NOPACK)
    `uvm_object_utils_end

    function new(string name = `MASTER_PACKET_NAME);
        super.new(name);
    endfunction: new

endclass: master_packet


class slave_packet #(
    parameter int unsigned DATA_WIDTH = 16
) extends base_packet;

    rand bit                      ready;
    rand data_kind_e              data_kind;

    bit                           vld;
    bit signed [DATA_WIDTH - 1:0] res;

    constraint data_kind_con {
        (data_kind == ZERO) -> res == 0;
        (data_kind == POS ) -> res  > 0;
        (data_kind == NEG ) -> res  < 0;
        (data_kind == SEMI) -> res != 0;
    }

    `uvm_object_utils_begin(slave_packet)
        `uvm_field_int (ready,     UVM_DEFAULT)
        `uvm_field_enum(data_kind, UVM_DEFAULT)
        `uvm_field_int (vld,       UVM_DEFAULT | UVM_NOPACK)
        `uvm_field_int (res,       UVM_DEFAULT | UVM_NOPACK)
    `uvm_object_utils_end

    function new(string name = `SLAVE_PACKET_NAME);
        super.new(name);
    endfunction: new

endclass: slave_packet