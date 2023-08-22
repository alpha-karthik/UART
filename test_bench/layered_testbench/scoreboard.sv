ass scoreboard;
  int compare_cnt;
  mailbox mon_to_sb;
  mailbox drv_to_sb;
  function new(mailbox mon_to_sb, mailbox drv_to_sb);
    this.mon_to_sb = mon_to_sb;
    this.drv_to_sb = drv_to_sb;
  endfunction
  
  task run;
    forever begin

      transaction tr;
      transaction tr1;
      tr = new();
      tr1 =new();
      mon_to_sb.get(tr);
      drv_to_sb.get(tr1);
      if (tr1.in_data == tr.out_data) begin
        $display("Matched Transmitter data = %0d Received data = %0d", tr1.in_data, tr.out_data); end
       else begin
         $display("NOT Matched Transmitter data = %0d Received data = %0d", tr1.in_data, tr.out_data);
       end
      $display("-------------------------------------------------------------------------------------");
      compare_cnt++;
      
    end
  endtask
endclass

