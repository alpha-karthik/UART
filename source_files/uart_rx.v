// Code your design here
module uart_rx(
  input clk,
  input areset,
  input baud_tick,
  input rx,
  output [7:0] out_data,
  output reg done
);
  parameter	IDLE	= 2'b00,
  			START	= 2'b01,
  			DATA	= 2'b10,
  			STOP	= 2'b11;
  reg [1:0] state,nstate;
  reg r;
  reg [7:0] data;
  reg [3:0] baud_tick_counter;
  reg [3:0] data_bits_counter;
  wire baud_tick_counter_w;   
  wire a;
//---------------------------------------------------------------------------------------------  
  always @(posedge clk)
    begin
      if (areset)
        state <= IDLE;
      else
        state <= nstate;
    end
  
  always @(*)
    begin
      case(state)
        IDLE	:	begin
          			nstate = ~rx ? START : IDLE;
          			
        			end
        START	:	begin
          			nstate = (baud_tick_counter == 4'd7 ) ? DATA : START;
        			end
        DATA	:	begin
          			nstate = (data_bits_counter == 4'd7 & baud_tick_counter == 4'd15) ? STOP : DATA;
        			end
        STOP	:	begin
          			nstate = (baud_tick_counter == 4'd15 ) ? IDLE : STOP;
        			end
        default	:	begin
          			nstate = IDLE;
        			end
      endcase
    end
  
  always @(posedge clk)
    begin
      if (areset) begin
        baud_tick_counter <= 4'd0;
      end
      else if (state == IDLE)
        baud_tick_counter <= 4'd0;
      else if (state == START & baud_tick_counter == 4'd7) 
        baud_tick_counter <= 4'd0;
      else if (baud_tick_counter == 4'd15)
        baud_tick_counter <= 4'd0;
      else if (baud_tick ) begin
        baud_tick_counter <= baud_tick_counter + 4'd1;
   
      end
      else
        baud_tick_counter <= baud_tick_counter;
    end
  
        
 
  always @(posedge clk)
    begin
      if (areset)
        data <= 8'd0;
      else if (state == DATA & a)
        data <= {rx,data[7:1]};
      else if (state == STOP)
        data <= data;
      else if (state == IDLE)
        data <= 8'd1;
      else 
        data <= data;
    end
  
  always @(posedge clk)
    begin
      if (areset)
        data_bits_counter = 4'd0;
      else if (data_bits_counter == 4'd7 & a)
        data_bits_counter  = 4'd0;
      else if ((state == DATA) & baud_tick_counter_w)
        data_bits_counter = data_bits_counter + 'd1;
      else
        data_bits_counter = data_bits_counter;
    end 
  
//---------------------------------------------------------------------------------------------
  
  assign  a = (state == DATA & baud_tick_counter_w);
  assign baud_tick_counter_w = (baud_tick_counter == 4'd15);
  assign done = (state == STOP);
  assign out_data = (data & {8{(state == STOP)}});
  
        
endmodule
        