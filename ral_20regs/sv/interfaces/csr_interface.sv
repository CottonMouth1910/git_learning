interface     csr_interface();

  // request channel
  logic               req_valid;
  logic               req_ready;
  logic               req_write;
  logic [7:0]         req_addr;     // byte address, word aligned
  logic [31:0]        req_wdata;

  // response channel
  logic               resp_valid;
  logic [31:0]        resp_rdata;

  // hardware side-band
  logic [31:0]        hw_status;    // drives REG1 (RO)
  logic [31:0]        hw_event;     // ORs into REG3(W1C)/REG16(RW1C)

  // driving cb
  clocking dr_cb @(posedge clk);
    output req_valid, req_write, req_addr, req_wdata;
    input  req_ready, resp_valid, resp_rdata;
  endclocking: dr_cb

  // monitoring cb
  clocking mon_cb @(posedge clk);
    input req_valid, req_write, req_addr, req_wdata;
    output req_ready, resp_valid, resp_rdata;
  endclocking: mon_cb
 
endinterface: csr_interface