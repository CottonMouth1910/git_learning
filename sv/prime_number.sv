module tb_top();
  int num;
  int cal_en;
  initial begin
    check_prime();
  end



  function void check_prime();
    for (num = 1; num <= 100; num++) begin
      if (is_prime(num)) begin
        $display("%0d is a prime number.", num);
      end else begin
        $display("%0d is not a prime number.", num);
      end
    end
  endfunction: check_prime

  initial begin
    $display("pull requst code");
  end // need to be merged
endmodule: tb_top