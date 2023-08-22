ass agent;
  driver drv;
  monitor mon;
  generator gen;
  
  mailbox gen_to_drv;
  mailbox drv_to_scb;
  virtual uart_if vif_a;
  virtual uart_if vif_b;
  
  function new(virtual uart_if vif_a,virtual uart_if vif_b, mailbox mon_to_sb, mailbox drv_to_scb);
    this.vif_a = vif_a;
    this.vif_b = vif_b;
    gen_to_drv = new();
    this.drv_to_scb = drv_to_scb;
    drv = new(gen_to_drv, drv_to_scb, vif_a, vif_b);
    mon = new(mon_to_sb, vif_b,vif_a);
    gen = new(gen_to_drv);
  endfunction
  
  task run();
    fork
      drv.run();
      mon.run();
      gen.run();
    join_any
  endtask
  
endclass
