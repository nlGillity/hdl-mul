# Import environment variables
set TOP $::env(TOP)
set OUT $::env(OUT)
set WAVES $::env(WAVES)
set COV $::env(COV)

# Create VCD
if $WAVES {
    vcd file $OUT/sim.vcd;
    vcd add $TOP/intf/*
}

# Run
if { ![batch_mode] && $WAVES } {
    add wave -position end sim:/$TOP/*
    add wave -noupdate -expand -group Interface /$TOP/intf/*
};
run -a;

# Coverage
if $COV {
    coverage report -details;
}

# Format and exit
if { ![batch_mode] && $WAVES } {config wave -signalnamewidth 1; wave zoom full};
if  [batch_mode] {exit -force};

