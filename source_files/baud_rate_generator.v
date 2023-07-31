module baud_rate_gen (
  input clk,
  input start,
  input rx,
  input [31:0] divisor,
  input areset,
  output out
);
  reg [31:0] counter;
  reg temp_out;
  always @(posedge clk, posedge areset)
    begin
      if (areset)
        counter <= 32'd0;
      else if (start & ~(counter==divisor))
        counter <= counter + 32'd1;
      else if (~start)
        counter <= 32'd0;
      else if (counter== divisor)
        counter <= 32'd0;
      else
        counter <= counter;
    end
  assign out = (counter == divisor);
endmodule