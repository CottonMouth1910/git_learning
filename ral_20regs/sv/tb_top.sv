`include "../rtl/csr_des.sv"
`include "interfaces/csr_intf.sv"

module tb_top();
  
  bit clk, rst_n;

  csr_interface csr_intf();

  csr_des csr_i(
     .clk        (clk                ),
     .rst_n      (rst_n              ),
     .req_valid  (csr_intf.req_valid ),
     .req_ready  (csr_intf.req_ready ),
     .req_write  (csr_intf.req_write ),
     .req_addr   (csr_intf.req_addr  ),
     .req_wdata  (csr_intf.req_wdata ),
     .resp_valid (csr_intf.resp_valid),
     .resp_rdata (csr_intf.resp_rdata),
     .hw_status  (csr_intf.hw_status ),
     .hw_event   (csr_intf.hw_event  )
  );

  initial begin
    fork
      clk_gen();
      rst_gen();
    join_none
    #200000us;
    
    $finish();
  end

  task clk_gen();
    forever begin
      clk = 1'b0; #5;
      clk = 1'b1; #5;
    end
  endtask
endmodule: tb_top