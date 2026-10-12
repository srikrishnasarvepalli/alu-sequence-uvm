class alu_test extends uvm_test;
 `uvm_component_utils(alu_test);
 
 alu_env tree; 
 alu_seq lead;
 function new(string name = "alu_test", uvm_component parent = null);
 super.new(name, parent);
 endfunction
 
 function void build_phase(uvm_phase phase);
   super.build_phase(phase);
   `uvm_info(get_type_name(), "We are inside of test, & in the building phase", UVM_MEDIUM);
   tree = alu_env::type_id::create("tree", this);
   
 endfunction
 
 task run_phase(uvm_phase phase);
 super.run_phase(phase);
 
    `uvm_info(get_type_name(), "We are inside of test, & in the run phase", UVM_MEDIUM);
	phase.raise_objection(this);
	 $display("my name is Sri Krishna Sarvepalli, here the sequence will run");
	lead = alu_seq::type_id::create("lead");
	lead.start(tree.spy.line);
#5;
	phase.drop_objection(this);

 endtask
endclass 

