import uvm_pkg::*;
`include "sequence_item.sv"
`include "sequence.sv"
`include "sequencer.sv"
`include "driver.sv"
`include "agent.sv"
`include "env.sv"
`include "test.sv"
module top();
import uvm_pkg::*;
 initial begin  
    run_test("alu_test");
 end
  initial begin  
#3000;
$finish;
 end
endmodule
