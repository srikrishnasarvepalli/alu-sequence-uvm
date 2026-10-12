 class alu_seq extends uvm_sequence;
 `uvm_object_utils(alu_seq);
 
 alu_seq_item model;
 
 function new (string name = "alu_seq");
  super.new(name);
  endfunction
  
  virtual task body();
     model=alu_seq_item::type_id::create("model");
  repeat(100) begin
   
  start_item(model);
  model.randomize() with {opcode==1;};
  finish_item(model);
 end 
   repeat(50) begin
  
  start_item(model);
  //mode.randomize() with {opcode==0 && a[4]==1 && b[4] ==1;};
	model.randomize() with {a[6]^b[6]^(((a+b) &(1<<6)) >> 6);};
  finish_item(model);
 
  end
  
  endtask
  
 
  endclass
