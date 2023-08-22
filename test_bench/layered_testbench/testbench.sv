LOCK_PERIOD_A 10
`define CLOCK_PERIOD_B 20
`define BAUD_RATE 9600
`include "packages.sv"
event over;
event dr;
event re;
module tb;
 
  bit clk_a;
  bit clk_b;
  bit areset_a;
  bit areset_b;
  bit [31:0] divisor_a;
  bit [31:0] divisor_b;
  
  
  //Interface declarations
  uart_if if_a(clk_a,areset_a);
  uart_if if_b(clk_b,areset_b);

  
  // UART module instantiations
  uart UART_1 (clk_a,areset_a,if_a);
  uart UART_2 (clk_b,areset_b,if_b); 
  
  assign if_a.rx = if_b.tx;
  assign if_b.rx = if_a.tx;
  assign if_b.divisor = divisor_b;
  assign if_a.divisor = divisor_a;
  
  base_test t1(if_a,if_b);
    
  
  // tasks
  always #5 clk_a = ~clk_a;
  always #10 clk_b = ~clk_b;
  
  //-------------------------------------------------------------
  task uart_initialise_a;
    #0 clk_a = 1'b0;
    #0 areset_a = 1'b0;
    #0 divisor_a = 1000000000/(`BAUD_RATE * `CLOCK_PERIOD_A * 16);
    @(posedge clk_a) areset_a = 1'b1;
    @(posedge clk_a) areset_a = 1'b0;
  endtask
  task uart_initialise_b;
    #0 clk_b = 1'b0;
    #0 areset_b = 1'b0;  
    #0 divisor_b = 1000000000/(`BAUD_RATE * `CLOCK_PERIOD_B * 16);
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
    -> over;
    //#8000000 $finish;

 
  end
endmodule
