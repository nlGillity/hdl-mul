package test_pkg;

    `include "items/packet.sv"

    `include "test/test_config.sv"

    `include "env/agents/master/master_driver.sv"
    `include "env/agents/master/master_monitor.sv"
    `include "env/agents/master/master_generator.sv"

    `include "env/agents/slave/slave_driver.sv"
    `include "env/agents/slave/slave_monitor.sv"

    `include "env/scoreboard.sv"

    `include "env/agents/master/master.sv"
    `include "env/agents/slave/slave.sv"

    `include "env/env.sv"

    `include "test/test.sv"
    `include "test/scenarios/test_overflow.sv"
    `include "test/scenarios/test_overwhelmed.sv"
    `include "test/scenarios/test_exhaustion.sv"
    `include "test/scenarios/test_intensive.sv"
    `include "test/scenarios/test_normal.sv"

endpackage
