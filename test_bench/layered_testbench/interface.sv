nterface uart_if(input logic clk, reset);
  logic [31:0] divisor;
  logic [7:0] in_data; // transmitting data through tx
  logic start;
  logic rx;				// receiver wire
  logic tx;				// transmitter wire
  logic tx_done;
  logic rx_done;
  logic [7:0] out_data; // received data through rx
endinterface
