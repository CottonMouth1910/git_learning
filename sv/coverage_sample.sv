module tb_top();

  bit [3:0] mode;
  

  covergroup cg;
    coverpoint mode;
  endgroup: cg
    cg cov= new();

  initial begin
    fork
      populate_mode();
      cover_mode();
    join_none

    #200;
    
    $display("Coverage report");
   $display("%0d/%0d", cov.mode.get_coverage(), cov.mode.get_inst_coverage());
    $finish();
  end


  task populate_mode();
    mode = 4'b0000;
    repeat(16) begin
      #5 mode++;
    end
  endtask: populate_mode

  task cover_mode();
    forever begin
      @(mode);
      cov.sample();
    end
  endtask: cover_mode
endmodule: tb_top