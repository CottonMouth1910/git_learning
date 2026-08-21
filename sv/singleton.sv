class singleton;
  
  singleton h_singleton;

  function new();
  endfunction: new

  static function singleton create();
    if(h_singleton == null) begin
      h_singleton = new();
    end
    return h_singleton;
  endfunction: create
endclass: singleton

module tb_top();
  singleton h_singleton;

  initial begin
    h_singleton = singleton::create();
    $display("h_singleton = %p", h_singleton);
  end
endmodule: tb_top