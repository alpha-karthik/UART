ass monitor;
  virtual uart_if vif_b;
  virtual uart_if vif_a;
  mailbox mon_to_sb;
  
  function new(mailbox mon_to_sb, virtual uart_if vif_b, virtual uart_if vif_a);
    this.vif_b = vif_b;
    this.vif_a = vif_a;
    this.mon_to_sb = mon_to_sb;
  endfunction
  
  function void display(transaction tr,virtual uart_if vif_b);
    $display(" Received Data from DUT with DATA = %0d, DIVISOR = %0d ", tr.out_data, vif_b.divisor);
  endfunction
  task run;
    forever begin
      transaction mon_tr;
      @(posedge vif_b.rx_done)
   
      mon_tr = new();
      mon_tr.out_data= vif_b.out_data;
      this.display(mon_tr, vif_b);
      mon_to_sb.put(mon_tr);
    end
  endtask
endclass
      
