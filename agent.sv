 class alu_agent extends uvm_agent;
 `uvm_component_utils(alu_agent);
 alu_seqr line;
 alu_driver car;
 
 function new(string name = "alu_agent", uvm_component parent = null);
 super.new(name, parent);
 endfunction
 
 function void build_phase(uvm_phase phase);
   super.build_phase(phase);
   `uvm_info(get_type_name(), "We are inside of agent, & in the building phase", UVM_MEDIUM);
   line = alu_seqr::type_id::create("line", this);
   car = alu_driver::type_id::create("car", this);
 endfunction
 
 function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
	`uvm_info(get_type_name(), "We are inside of agent, & in the connection phase", UVM_MEDIUM);
	car.seq_item_port.connect(line.seq_item_export);
	
 endfunction 
 endclass
