ass driver;
  virtual uart_if vif_a;
  virtual uart_if vif_b;
  mailbox gen_to_drv;
  mailbox drv_to_scb;
  transaction tr;
  transaction tr1;
  int count;
  
  
  function new(mailbox gen_to_drv, mailbox drv_to_scb,virtual uart_if vif_a, virtual uart_if vif_b);
    this.gen_to_drv = gen_to_drv;
    this.drv_to_scb = drv_to_scb;
    this.vif_a = vif_a;
    this.vif_b = vif_b;
  endfunction
  
  function void display(transaction tr,virtual uart_if vif_a);
    $display(" Driving Data to DUT with DATA = %0d,START = %0d, DIVISOR = %0d ", tr.in_data, tr.start, vif_a.divisor);
  endfunction
  
  
  task run;
    repeat(count) begin
      
    gen_to_drv.get(tr);
      tr1 = new tr;
      drv_to_scb.put(tr1);
    
      this.display(tr,vif_a);
      vif_a.in_data = tr.in_data;
      vif_a.start   = tr.start;
      @(posedge vif_a.tx_done);
    end
  endtask
endclass
     
      
    
    
    
    
        
          
      
  
      
      
