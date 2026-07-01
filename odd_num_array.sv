module tb_top();
  int arr[];

  initial begin
    std::randomize(arr) with {
      arr.size() == 6;
      arr.sum() with  (item inside {1,2,3,4} ? 1: 0) == arr.size();
    }

    $display("arr : %p", arr);
  end
endmodule: tb_top