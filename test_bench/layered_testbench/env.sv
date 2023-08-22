ass env;
  agent agt;
  scoreboard sb;
  mailbox drv_to_sb;
  mailbox mon_to_sb;
  function new(virtual uart_if vifa, virtual uart_if vifb);
    drv_to_sb = new();
    mon_to_sb = new();
    agt = new(vifa,vifb, mon_to_sb,drv_to_sb);
    sb = new(mon_to_sb,drv_to_sb);
  endfunction
  
  task run();
    fork
      agt.run();
      sb.run();
    join_any
    wait(agt.gen.count == sb.compare_cnt);
    $finish;
  endtask
endclass

