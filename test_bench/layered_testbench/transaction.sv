ass transaction;
  rand bit start;
  rand bit [7:0] in_data;
  bit rx;
  bit tx;
  bit tx_done;
  bit rx_done;
  bit [7:0] out_data;
  
  constraint on_start   { start == 1;}
  
  
endclass
