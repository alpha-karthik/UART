ase_test(uart_if vif_a,uart_if vif_b);
  env env_o;
  
  initial begin
    env_o = new(vif_a,vif_b);
    env_o.agt.gen.count = 10;
    env_o.agt.drv.count = 10;
    wait(over.triggered);
    env_o.run();
  end
endprogram

