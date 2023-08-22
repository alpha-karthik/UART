ass generator;
  int count;
  mailbox gen_to_drv;
  transaction tr;
  
  function new(mailbox gen_to_drv);
    this.gen_to_drv = gen_to_drv;
  endfunction
  
  task run;
    repeat(count) begin
      tr = new();
      void'(tr.randomize());
      gen_to_drv.put(tr);
    end
  endtask
endclass
