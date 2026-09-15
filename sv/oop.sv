class transfer;
  int a;

  function void func1(transfer xfer);
    $display("before reconstruction @ func1: xfer.a = %0d", xfer.a);
    xfer   = new();
    xfer.a = 20;
    $display("after reconstruction @ func1: xfer.a = %0d", xfer.a);
  endfunction: func1

  function void func2(ref transfer xfer);
    $display("before reconstruction @ func2: xfer.a = %0d", xfer.a);
    xfer   = new();
    xfer.a = 30;
    $display("after  reconstruction @ func2: xfer.a = %0d", xfer.a);
    $display("after  reconstruction @ active obj: xfer.a = %0d", this.a);
  endfunction: func2

endclass: transfer

module     tb_top();

   transfer xfer;

  initial begin
    xfer   = new();
    xfer   = new();
    xfer.a = 10;

    xfer.func1(xfer);
    $display("after func1: xfer.a = %0d", xfer.a);
    $display();
    xfer.func2(xfer); 
    $display("after func2: xfer.a = %0d", xfer.a);
  end
endmodule: tb_top

