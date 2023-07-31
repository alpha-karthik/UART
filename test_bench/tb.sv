// Code your testbench here
// or browse Examples
module tb;
  // UART 1 PORTS
  bit clk_a;
  bit start_a;
  bit [31:0] divisor_a;
  bit areset_a;
  bit [7:0] in_data_a;
  bit rx_a;
  wire tx_a;
  wire tx_done_a;
  wire rx_done_a;
  wire [7:0] out_data_a;
  wire [7:0] aa;
  wire baud_tick_a;
  // UART 2 PORTS
  bit clk_b;
  bit start_b;
  bit [31:0] divisor_b;
  bit areset_b;
  bit [7:0] in_data_b;
  bit rx_b;
  wire tx_b;
  wire tx_done_b;
  wire rx_done_b;
  wire [7:0] out_data_b;
  wire [7:0] bb;
  wire baud_tick_b;

  assign rx_b = tx_a;
  assign rx_a = tx_b;
  
  // UART module instantiations
  uart UART_1 (clk_a, areset_a, start_a, divisor_a, baud_tick_a, in_data_a, tx_a, tx_done_a, rx_a, out_data_a,rx_done_a );
  uart UART_2 (clk_b, areset_b, start_b, divisor_b, baud_tick_b, in_data_b, tx_b, tx_done_b, rx_b, out_data_b,rx_done_b ); 
  //uart_tx t (clk,baud_tick,areset,data,start,tx,done);
  //baud_rate_gen b (clk, start, divisor, areset, baud_tick);
  //uart_rx u (clk,areset,baud_tick,tx,data_out,rx_done_tick); 
  // tasks
  always #5 clk_a = ~clk_a;
  always #10 clk_b = ~clk_b;
  task uart_initialise_a;
    #0 clk_a = 1'b0;
    #0 areset_a = 1'b0;
    #0 divisor_a = 651;
    @(posedge clk_a) areset_a = 1'b1;
    @(posedge clk_a) areset_a = 1'b0;
  endtask
  task uart_initialise_b;
    #0 clk_b = 1'b0;
    #0 areset_b = 1'b0;
    #0 divisor_b = 326;
    
    @(posedge clk_b) areset_b = 1'b1;
    @(posedge clk_b) areset_b = 1'b0;
  endtask
 
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars();
  end
  initial begin
    $display("Starting Initialsing");
    fork
      uart_initialise_a ;
      uart_initialise_b ;
    join
    $display("Ending Initialising");
    
    
    #2 start_a = 1'b1; start_b = 1'b0; in_data_a = $random;
    repeat (10)
      begin
        @(tx_done_a) in_data_a = $random;
        $display("Generating Random data = 0x%0d", in_data_a);
        @(rx_done_b) 
        $display(" Received Transmitted data = 0x%0d",out_data_b);
        
      end
    #8000 $finish;
  end
    
  
endmodule