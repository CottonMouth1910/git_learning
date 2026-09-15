module clock_div(
  input logic clk_100MHz
);

logic clock_50MHz;
logic clock_25MHz;

always @(posedge clk_100MHz) begin
  clock_50MHz <= ~clock_50MHz;
end

always @(posedge clock_50MHz) begin
  clock_25MHz <= ~clock_25MHz;
end
endmodule: clock_div


module tb_top();
  bit clk;
  
  clock_div dut(
    .clk_100MHz(clk)
  );
  
  initial begin
    repeat (100) begin
      #5 clk = ~clk;
    end
  end
endmodule