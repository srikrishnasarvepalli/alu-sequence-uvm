 class alu_seq_item extends uvm_sequence_item;
 `uvm_object_utils(alu_seq_item);
 rand bit signed [35:0] a;
 rand bit signed [20:0] b;
 rand bit opcode;
 rand bit ci;
 bit signed[35:0] z;
 bit co; 
//constraint small_numbers {a<100 && a>0 && b<100 && b>0;};
// constraint carry_in {ci==0;};
 function new (string name = "alu_seq_item");
  super.new(name);
  endfunction
  endclass
