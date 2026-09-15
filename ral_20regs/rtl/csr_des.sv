//=============================================================================
// csr_20regs.sv
// 20 registers, one per uvm_reg_field access policy string -> use this to
// build a matching RAL model (uvm_reg_field::configure(.access("<TYPE>"))).
//
// Protocol: single-cycle valid request, no backpressure, 1-cycle valid resp.
//   req_valid/req_write/req_addr/req_wdata -> req_ready (always 1)
//   next cycle: resp_valid + resp_rdata
//
// idx | name        | access | behavior
//  0  | REG_RW      | RW     | plain read/write
//  1  | REG_RO      | RO     | reads hw_status, writes ignored
//  2  | REG_WO      | WO     | write stored, read always returns 0
//  3  | REG_W1C     | W1C    | write1 clears bit; hw_event ORs bits in (set-dominant is sw's job)
//  4  | REG_W1S     | W1S    | write1 sets bit
//  5  | REG_W1T     | W1T    | write1 toggles bit
//  6  | REG_W0C     | W0C    | write0 clears bit
//  7  | REG_W0S     | W0S    | write0 sets bit
//  8  | REG_W0T     | W0T    | write0 toggles bit
//  9  | REG_WC      | WC     | any write clears whole reg
// 10  | REG_WS      | WS     | any write sets whole reg
// 11  | REG_WSRC    | WSRC   | write sets bits, read clears whole reg
// 12  | REG_WCRS    | WCRS   | write clears bits, read sets whole reg
// 13  | REG_WO1     | WO1    | first write only, locked after
// 14  | REG_RC      | RC     | read clears whole reg
// 15  | REG_RS      | RS     | read sets whole reg
// 16  | REG_RW1C    | RW1C   | readable + write1 clears; hw_event ORs bits in
// 17  | REG_RW1S    | RW1S   | readable + write1 sets
// 18  | REG_WRC     | WRC    | normal write, read clears after
// 19  | REG_WRS     | WRS    | normal write, read sets after
//=============================================================================

module csr_20regs #(
  parameter int ADDR_W   = 8,
  parameter int DATA_W   = 32,
  parameter int NUM_REGS = 20
)(
  input  logic              clk,
  input  logic              rst_n,

  // request channel
  input  logic               req_valid,
  output logic                req_ready,
  input  logic               req_write,
  input  logic [ADDR_W-1:0]  req_addr,     // byte address, word aligned
  input  logic [DATA_W-1:0]  req_wdata,

  // response channel
  output logic                resp_valid,
  output logic [DATA_W-1:0]   resp_rdata,

  // hardware side-band
  input  logic [DATA_W-1:0]   hw_status,    // drives REG1 (RO)
  input  logic [DATA_W-1:0]   hw_event      // ORs into REG3(W1C)/REG16(RW1C)
);

  localparam int IDX_W = $clog2(NUM_REGS);

  logic [DATA_W-1:0] regs [NUM_REGS];
  logic              wo1_locked;
  logic [IDX_W-1:0]  idx;
  logic [DATA_W-1:0] reg3_next, reg16_next;

  assign idx       = req_addr[IDX_W+1:2];
  assign req_ready = 1'b1;   // single cycle, always accepts

  function automatic [DATA_W-1:0] read_val(input logic [IDX_W-1:0] i);
    unique case (i)
      1:       read_val = hw_status;  // RO
      2:       read_val = '0;         // WO
      default: read_val = regs[i];
    endcase
  endfunction

  // set-dominant next state for the two hw-updated registers, computed
  // combinationally so a hw set and a sw clear in the same cycle don't race.
  always_comb begin
    reg3_next  = regs[3]  | hw_event;
    reg16_next = regs[16] | hw_event;
    if (req_valid && req_write) begin
      if (idx == 3)  reg3_next  = reg3_next  & ~req_wdata;
      if (idx == 16) reg16_next = reg16_next & ~req_wdata;
    end
  end

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      foreach (regs[i]) regs[i] <= '0;
      wo1_locked <= 1'b0;
      resp_valid <= 1'b0;
      resp_rdata <= '0;
    end else begin
      resp_valid <= req_valid;
      regs[3]    <= reg3_next;
      regs[16]   <= reg16_next;

      if (req_valid) begin
        resp_rdata <= read_val(idx);   // captured pre-update

        if (req_write) begin
          unique case (idx)
            0:  regs[0]  <= req_wdata;                 // RW
            2:  regs[2]  <= req_wdata;                 // WO
            4:  regs[4]  <= regs[4]  |  req_wdata;      // W1S
            5:  regs[5]  <= regs[5]  ^  req_wdata;      // W1T
            6:  regs[6]  <= regs[6]  &  req_wdata;      // W0C
            7:  regs[7]  <= regs[7]  | ~req_wdata;      // W0S
            8:  regs[8]  <= regs[8]  ^ ~req_wdata;      // W0T
            9:  regs[9]  <= '0;                         // WC
            10: regs[10] <= '1;                         // WS
            11: regs[11] <= regs[11] | req_wdata;       // WSRC
            12: regs[12] <= regs[12] & ~req_wdata;       // WCRS
            13: if (!wo1_locked) begin                  // WO1
                  regs[13]   <= req_wdata;
                  wo1_locked <= 1'b1;
                end
            17: regs[17] <= regs[17] | req_wdata;       // RW1S
            18: regs[18] <= req_wdata;                  // WRC
            19: regs[19] <= req_wdata;                  // WRS
            default: ;                                  // RO,W1C,W0T-done,RC,RS,RW1C handled elsewhere/read-only
          endcase
        end else begin
          unique case (idx)
            11: regs[11] <= '0;   // WSRC - read clears
            12: regs[12] <= '1;   // WCRS - read sets
            14: regs[14] <= '0;   // RC   - read clears
            15: regs[15] <= '1;   // RS   - read sets
            18: regs[18] <= '0;   // WRC  - read clears
            19: regs[19] <= '1;   // WRS  - read sets
            default: ;
          endcase
        end
      end
    end
  end

`ifdef CSR_ASSERT_ON
  property p_addr_range;
    @(posedge clk) disable iff (!rst_n) req_valid |-> (idx < NUM_REGS);
  endproperty
  a_addr_range: assert property (p_addr_range);

  property p_resp_after_req;
    @(posedge clk) disable iff (!rst_n) req_valid |=> resp_valid;
  endproperty
  a_resp_after_req: assert property (p_resp_after_req);
`endif

endmodule