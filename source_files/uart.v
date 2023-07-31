// Design of UART Protocol
`include "baud_generator.v"
`include "uart_rx.v"
`include "uart_tx.v"

module uart(
  input clk,
  input areset,
  input start,
  // UART Baud rate generator ports
  input [31:0] divisor,
  output baud_tick,
  // UART Transmitter ports
  input [7:0] data,
  output tx,
  output tx_done,
  // UART Receiver ports
  input rx,
  output [7:0] received_data,
  output rx_done
  
);
  reg START,ARESET;
  wire rx_or_tx;
  // module instantiations
  baud_rate_gen b ( .clk(clk), .start(rx_or_tx), .divisor(divisor), .areset(areset), .out(baud_tick) );
  uart_tx t ( .clk(clk) ,.baud_tick(baud_tick), .areset(areset), .data(data), .start(start), .tx(tx), .done(tx_done));
  uart_rx r ( .clk(clk), .areset(areset), .baud_tick(baud_tick), .rx(rx), .out_data(received_data),  .done(rx_done));
  
  // For starting the Baud_rate_generator when either Transmitter starts sending the data or Receiver Starts receiving the data.
  always @(posedge clk)
    begin
      if (areset)
        START = 1'b0;
      else if ((start | ~rx) & ~START)
        START = 1'b1;
      else
        START = START;
    end
  
  assign rx_or_tx = START;
  
  
endmodule
             
                   
                   

