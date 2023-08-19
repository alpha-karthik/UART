// Design of UART Protocol
`include "baud_generator.v"
`include "uart_rx.v"
`include "uart_tx.v"

module uart(
  input clk,
  input reset,
  uart_if vif
  
);
  reg START,ARESET;
  wire rx_or_tx;
  // module instantiations

  baud_rate_gen b ( .clk(clk), .start(rx_or_tx), .divisor(vif.divisor), .areset(reset), .out(vif.baud_tick) );
  uart_tx t ( .clk(clk) ,.baud_tick(vif.baud_tick), .areset(reset), .data(vif.in_data), .start(vif.start), .tx(vif.tx), .done(vif.tx_done));
  uart_rx r ( .clk(clk), .areset(reset), .baud_tick(vif.baud_tick), .rx(vif.rx), .out_data(vif.out_data),  .done(vif.rx_done));
  
  // For starting the Baud_rate_generator when either Transmitter starts sending the data or Receiver Starts receiving the data.
  always @(posedge clk)
    begin
      if (reset)
        START = 1'b0;
      else if ((vif.start | ~vif.rx) & ~START)
        START = 1'b1;
      else
        START = START;
    end
  
  assign rx_or_tx = START;
  
  
endmodule
             
                   
                   

