class cricket;
  
  rand int match_score[20][6];

  function new();
    $display("cricket match started");
  endfunction: new

  constraint match_score_c {
    match_score.sum() with (
      (
        (item.sum() with (item >= 4            ? 1 : 0) >= 1) &&
        (item.sum() with (item inside {[0:6]}  ? 1 : 0) == 6)
      ) ? 1 : 0 
    ) == 20;
  };

  function void post_randomize();
    foreach (match_score[i]) begin
      $display("%p", match_score[i]);
    end
  endfunction: post_randomize

endclass: cricket


module tb_top();
  cricket cric;

  initial begin
    cric = new();
    if (!cric.randomize()) begin
      $display("Randomization failed");
    end
  end
endmodule: tb_top