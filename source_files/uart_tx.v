module uart_tx(
  input clk,
  input baud_tick,
  input areset,
  input [7:0] data,
  input start, 
  output tx,
  output reg done
);
  reg TX;
  parameter	IDLE	= 2'b00,
  			START	= 2'b01,
  			DATA	= 2'b10,
  			STOP	= 2'b11;
  wire baud_tick_counterw;
  wire some;
  reg [3:0] baud_tick_counter;
  reg [3:0] data_bits_counter;
  reg [7:0] PISO;
  reg Baud;
  reg [1:0] state, nstate;
//---------------------------------------------------------------------------------------------
  always @(posedge clk)
    begin
      if (areset)
        state <= IDLE;
      else if (baud_tick_counterw)
        state <= nstate;
      else 
        state <= state;
    end
   always @(*)
    begin
      case(state)
        IDLE	: nstate = start ? START : IDLE;
        START	: nstate = DATA;
        DATA	: nstate = (data_bits_counter != 4'd8) ? DATA :STOP;
        STOP	: nstate = IDLE;
        default	: nstate = IDLE;
      endcase
    end
  //this block corresponds to count the no of baud ticks, if they are 16 then we need to change the states or change the signal values 
  always @(posedge clk) 
    begin
      if (areset) begin
        Baud <= 1'b0;
        baud_tick_counter = 4'd0; end
      else if (baud_tick_counter == 4'd15) begin
        baud_tick_counter = 4'd0;
        Baud <= 1'b0; end
      else if (baud_tick) begin 
        if (baud_tick_counter == 4'd14) Baud <= 1'b1;
        else Baud <= 1'b0; 
          baud_tick_counter = baud_tick_counter + 'd1; 
      end
      else 
        baud_tick_counter = baud_tick_counter; 
    end
  always @(posedge clk)
    begin
      if (areset)
        data_bits_counter = 4'd0;
      else if (data_bits_counter == 4'd8)
        data_bits_counter  = 4'd0;
      else if ((state == DATA) & baud_tick_counterw)
        data_bits_counter = data_bits_counter + 'd1;
      else
        data_bits_counter = data_bits_counter;
    end
 
  always @(posedge clk)
    begin
      if (areset)
        PISO <= 8'd1;
      else if (nstate == START &  baud_tick_counterw)
        PISO <= data;
      else if ((state == DATA) & (baud_tick_counterw))
        PISO <= {1'b1,PISO[7:1]};
      else
        PISO <= PISO;
    end
 
  assign tx =(state == START ) ? 1'b0 : (state == DATA) ? PISO[0] : 1'b1;
  always @(posedge clk) begin
    if (areset)
      done <= 1'b0;
    else if (baud_tick_counterw & state == STOP)
      done <= 1'b1;
  	else
      done <= 1'b0;
  end
//---------------------------------------------------------------------------------------------
  assign some  = (baud_tick_counter == 4'd15 & baud_tick);
  assign baud_tick_counterw = (baud_tick_counter == 4'd15 );
  assign tx =(state == START ) ? 1'b0 : (state == DATA) ? PISO[0] : 1'b1;

endmodule