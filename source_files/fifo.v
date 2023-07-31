// Code your design here
/* Design of Synchronous FIFO Design
Specifications:
Data size = 8 bits or 1 byte
Address size = 4 bits 
No of data elements will be [15:0] which is equal to [1<<ASIZE:0]
Both read and write counters are updated by the same clock
need to specify the logic for full and empty conditions by utilising the Almost Full and Almost empty scenarios
*/
module fifo_core #(parameter DSIZE = 8, ASIZE = 4)
  (
    input clk,
    input w_en,
    input r_en,
    input [ASIZE-1:0] w_addr,
    input [ASIZE-1:0] r_addr,
    input [DSIZE-1:0] w_data,
    output [DSIZE-1:0] r_data
  );
  reg [DSIZE-1:0] r_data_temp;
  parameter MEMDEPTH = 1<<ASIZE;
  reg [DSIZE-1:0] fifo_mem [0:1<<MEMDEPTH-1];
  always @(posedge clk)
    begin
      fifo_mem[w_addr] <= w_en ? w_data : fifo_mem[w_addr];
      r_data_temp		   <= r_en ? fifo_mem[r_addr] : 'd0;
    end
  assign r_data = r_data_temp;
endmodule

module write_block #(parameter ASIZE = 4)
  (
    input clk,
    input wen,
    input full,
    input resetn,
    output [ASIZE-1:0] write_addr
  );
  
  wire wen_q;
  assign wen_q = ~full & wen ;
  reg [ASIZE-1:0] w_counter;
  always @(posedge clk)
    begin
      if (~resetn)
        w_counter <= 'd0;
      else if (wen_q)
        w_counter <= w_counter + 'd1;
      else
        w_counter <= w_counter;
    end
  assign write_addr = w_counter;
endmodule

module read_block #(parameter ASIZE = 4)
  (
    input clk,
    input resetn,
    input empty,
    input ren,
    output [ASIZE-1:0] read_addr
  );
  
  wire ren_q;
  assign ren_q = ~empty & ren;
  reg [ASIZE-1:0] r_counter;
  always @(posedge clk)
    begin
      if (~resetn)
        r_counter <= 'd0;
      else if (ren_q)
        r_counter <= r_counter + 'd1;
      else
        r_counter<= r_counter;
      
    end
  assign read_addr = r_counter;
endmodule

module diff_logic #(parameter ASIZE = 4)
  (
    input [ASIZE-1:0] w_addr, 
    input [ASIZE-1:0]r_addr,
    output [ASIZE-1:0] out_diff
  );
  assign out_diff = w_addr + (~r_addr) + 'd1;
endmodule


module full_empty_comb #(parameter ASIZE = 4)
  (
    input clk,
    input resetn,
    input [ASIZE-1:0] in_diff,
    output full,
    output empty
  );
  wire RAF, RAE;
  wire AF, AE;
  reg ff;
  assign RAF = in_diff[2] & in_diff[1];
  assign RAE = ~in_diff[2] & in_diff[1];
  always @(posedge clk)
    begin
      if (resetn)
        ff <= 'd0;
      else if ( RAF & ~RAE)
        ff <= 'd1;
      else if ( ~RAF & RAE)
        ff <= 'd0;
      else
        ff <= ff;
    end
  assign AF = ff;
  assign AE = ~ff;
  assign full = AF & (&(~in_diff));
  assign empty = AE & (&(~in_diff));
  
endmodule

module fifo #(parameter DSIZE = 8, ASIZE =4)
  (
    input clk,
    input resetn,
    input wen,
    input ren,
    output full,
    output empty,
    input [DSIZE-1:0] wdata,
    output [DSIZE-1:0] rdata
  );
  // Wire Instantiations
  assign W_EN = wen;
  assign R_EN = ren;
  assign full = FULL;
  assign empty = EMPTY;
  wire W_EN,R_EN,FULL,EMPTY;
  wire [ASIZE-1:0] W_ADDR,R_ADDR,OUT_DIFF;
  //module instantiations
  fifo_core  #(DSIZE, ASIZE) fc (clk,W_EN,R_EN,W_ADDR,R_ADDR,wdata,rdata);
  write_block #(ASIZE) wb  (clk,W_EN,FULL,resetn,W_ADDR);
  read_block #(ASIZE) rb  (clk,resetn,EMPTY,R_EN,R_ADDR);
  diff_logic #(ASIZE) db  (W_ADDR, R_ADDR, OUT_DIFF);
  full_empty_comb #(ASIZE) fec (~clk,resetn,OUT_DIFF,FULL,EMPTY);
endmodule

        
  


        
  
  
  
