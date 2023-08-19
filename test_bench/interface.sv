interface uart_if(input logic clk, reset);
  logic [31:0] divisor;
  logic [7:0] in_data;
  logic start;
  logic rx;
  logic tx;
  logic tx_done;
  logic rx_done;
  logic [7:0] out_data;
  //logic [7:0] aa;
  logic baud_tick;
endinterface