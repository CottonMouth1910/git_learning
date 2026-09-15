module matrix();

  bit [3:0] arr [2][2];

  initial begin
    foreach (arr[i]) begin
      foreach (arr[i][j]) begin
        arr[i][j] = $urandom_range(0, 9);
      end
    end
    $display("Matrix: ");

    foreach (arr[i]) begin
      foreach (arr[i][j]) begin
        $write("%0d ", arr[i][j]);
      end
      $display("");
    end
  end
endmodule: matrix