
`include "interface.sv"
module tb;
 
  bit clk_a;
  bit clk_b;
  bit areset_a;
  bit areset_b;
  
  
  //Interface declarations
  uart_if u(clk_a,areset_a);
  uart_if x(clk_b,areset_b);

  
  
  // UART module instantiations
  uart UART_1 (clk_a,areset_a,u);
  uart UART_2 (clk_b,areset_b,x); 
  assign x.rx = u.tx;
  assign u.rx = x.tx;
  
  // tasks
  always #5 clk_a = ~clk_a;
  always #10 clk_b = ~clk_b;
  
  //-------------------------------------------------------------
  task uart_initialise_a;
    #0 clk_a = 1'b0;
    #0 areset_a = 1'b0;
    #0 u.divisor = 651;
    @(posedge clk_a) areset_a = 1'b1;
    @(posedge clk_a) areset_a = 1'b0;
  endtask
  task uart_initialise_b;
    #0 clk_b = 1'b0;
    #0 areset_b = 1'b0;
    #0 x.divisor = 326;
    
    @(posedge clk_b) areset_b = 1'b1;
    @(posedge clk_b) areset_b = 1'b0;
  endtask
 
  //--------------------------------------------------------------
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars();
  end
  //--------------------------------------------------------------
  initial begin
    $display("Starting Initialsing");
    fork
      uart_initialise_a ;
      uart_initialise_b ;
    join
    $display("Ending Initialising");
    
    
    #2 u.start = 1'b1; x.start = 1'b0; u.in_data = $random;
    repeat (10)
      begin
        @(u.tx_done) u.in_data = $random;
        $display("Generating Random data = 0x%0d", u.in_data);
        @(x.rx_done) 
        $display(" Received Transmitted data = 0x%0d",x.out_data);
        
      end
    #8000 $finish;
  end
endmodule