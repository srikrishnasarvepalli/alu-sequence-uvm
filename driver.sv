 class alu_driver extends uvm_driver #(alu_seq_item); 
 `uvm_component_utils(alu_driver);

alu_seq_item num;

  function new (string name = "alu_driver", uvm_component parent = null);
   super.new(name,parent);
  endfunction
  
 function void build_phase(uvm_phase phase);
 super.build_phase(phase);
 `uvm_info(get_type_name(), "We are inside of driver, & in the building phase", UVM_MEDIUM);
 endfunction 
 
   function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
	 `uvm_info(get_type_name(), "We are inside of driver, & in the connection phase", UVM_MEDIUM);
	//car.seq_item_port.connect(sqr_handle.seq_item_export);
 endfunction 
 
 
  task run_phase(uvm_phase phase);
 super.run_phase(phase);

  `uvm_info(get_type_name(), "We are inside of driver, & in the run phase", UVM_MEDIUM);
$display("printing the pattern data in driver here (EE273 HW2) :");
   forever begin
//code

 
 num=alu_seq_item::type_id::create("num");
  seq_item_port.get_next_item(num);
  
  if(num.opcode==0)
  num.z=num.a + num.b;
  else if (num.opcode==1)
  num.z=num.a ^ num.b;
 
  

 $display("Data inside driver is: a=%b b=%b opcode=%b ci=%b z=%b co=%b ", num.a,num.b,num.opcode, num.ci,num.z,num.co);
 seq_item_port.item_done();
 #1;
end   
 
 endtask
 
 
 endclass

