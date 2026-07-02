class 20_over_cricket;
  
  rand int match_score[20][6];

  function new();
    $display("cricket match started");
  endfunction: new

  constraint match_score_c {
    match_score.sum() with (item.sum() inside {[0:6]} ? 1 : 0) == match_score.size();
  };

  function void post_randomize();
    foreach (match_score[i]) begin
      $display("%p", match_score[i]);
    end
  endfunction: post_randomize

endclass: 20_over_cricket


module tb_top();
  20_over_cricket cricket;

  initial begin
    cricket = new();
    if (!cricket.randomize()) begin
      $display("Randomization failed");
    end
  end
endmodule: tb_top