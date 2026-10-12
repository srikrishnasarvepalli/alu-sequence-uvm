class alu_env extends uvm_env;
 `uvm_component_utils(alu_env);
 
 alu_agent spy;
 
 function new(string name = "alu_env", uvm_component parent = null);
 super.new(name, parent);
 endfunction
 
 function void build_phase(uvm_phase phase);
   super.build_phase(phase);
   `uvm_info(get_type_name(), "We are inside of env, and in the building phase", UVM_MEDIUM);
   spy = alu_agent::type_id::create("spy", this);
   
 endfunction
endclass
