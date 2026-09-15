module double_flop (
  input logic clk,
  input logic rst_n,
  input logic d,
  output logic q1, 
  output logic q2
);
  logic fq1;
  logic fq2;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      fq1 <= 1'b0;
      fq2 <= 1'b0;
    end else begin
      fq1 <= d;
      fq2 <= fq1;
    end
  end

  assign q1 = fq1;
  assign q2 = fq2;
endmodule: double_flop


module tb_top();
  bit clk;
  bit rst_n;
  bit d;
  bit q1;
  bit q2;

  double_flop dut (
    .clk(clk),
    .rst_n(rst_n),
    .d(d),
    .q1(q1),
    .q2(q2)
  );

   
  initial begin
    fork
      clk_gen();
      rst_gen();
      stimulus();
    join_none
    #500  $finish();
  end

  task clk_gen();
    forever begin
      #2 clk = ~clk;
    end
  endtask: clk_gen

  task rst_gen();
    rst_n = 1'b1;
    #2 rst_n = 1'b0;
    @(posedge clk);
    @(posedge clk);
    rst_n = 1'b1;
  endtask: rst_gen

  task stimulus();
    @(negedge rst_n);
    @(posedge rst_n);

    @(posedge clk);
    @(negedge clk);

    d = 1'b0;
    @(negedge clk);
    d = 1'b1;
    @(negedge clk);
    d = 1'b0;
    @(negedge clk);
    d = 1'b1;
    @(negedge clk);
    d = 1'b0;
    @(negedge clk);
  endtask: stimulus
endmodule: tb_top