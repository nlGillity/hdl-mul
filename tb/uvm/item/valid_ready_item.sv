/// @file valid_ready_item.sv
/// @brief Valid-Ready sequence item
/// @author Danil Zavarnitsyn

class valid_ready_item #(
    valid_ready_params_s PARAMS = DEFAULT_PARAMS
) extends uvm_sequence_item;

    `uvm_object_param_utils(valid_ready_item#(PARAMS))

    //--------------------------------------------------------------------
    // Type aliases
    //--------------------------------------------------------------------

    typedef valid_ready_item#(PARAMS) item_t;
    typedef bit [PARAMS.data_width - 1:0] data_t;

    //--------------------------------------------------------------------
    // Properties
    //--------------------------------------------------------------------

    // Validity
    rand bit valid;
    // Operands
    rand data_t data [0:PARAMS.data_num - 1];

    //--------------------------------------------------------------------
    // Methods
    //--------------------------------------------------------------------

    extern function new(string name);
    extern virtual function bit  do_compare(uvm_object rhs, uvm_comparer comparer);
    extern virtual function void do_copy(uvm_object rhs);
    extern virtual function string convert2string();

endclass: valid_ready_item


function valid_ready_item::new(string name);
    super.new(name);
endfunction: new


function bit valid_ready_item::do_compare(uvm_object rhs, uvm_comparer comparer);
    item_t rhs_;
    bit    result;

    if ( !$cast(rhs_, rhs) )
        `uvm_fatal({get_name(), ".cast_failed"}, "Cast to the valid_ready_item failed.")

    if ( PARAMS.data_num != rhs_.PARAMS.data_num )
        `uvm_error(
            get_name(), 
            $sformatf(
                "Data size mismatch: this = %0d rhs = %0d",
                this.PARAMS.data_num, rhs_.PARAMS.data_num
            )
        )

    result = super.do_compare(rhs, comparer);

    foreach (data[i]) begin
        result = result && comparer.compare_field_int(
            .name ( $sformatf("data[%0d]", i)       ),
            .lhs  ( uvm_bitstream_t'(rhs_.data[i]) ),
            .rhs  ( uvm_bitstream_t'(this.data[i]) ),
            .size ( int'($bits(this.data[i]))      )
        );
    end

    result = result && comparer.compare_field_int(
        .name ( "valid"                      ),
        .lhs  ( uvm_bitstream_t'(rhs_.valid) ),
        .rhs  ( uvm_bitstream_t'(this.valid) ),
        .size ( int'($bits(this.valid))      )
    );

    return result;
endfunction: do_compare


function void valid_ready_item::do_copy(uvm_object rhs);
    item_t rhs_;

    if ( !$cast(rhs_, rhs) )
        `uvm_fatal({get_name(), ".cast_failed"}, "Cast to the valid_ready_item failed.")

    super.do_copy(rhs);
    valid = rhs_.valid;
    data  = rhs_.data;
endfunction: do_copy


function string valid_ready_item::convert2string();
    string str = "";
    str = { str, "Items:\n"                                        };
    str = { str, $sformatf("\tvalid     : 'b%b\n", valid)          };
    str = { str, $sformatf("\tdata_kind : %s\n", data_kind.name()) };
    foreach (data[i])
        str = { str, $sformatf("\tdata[%d]  : 'h%h\n", i, data[i]) };
    return str;
endfunction: convert2string
