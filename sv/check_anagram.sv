module tb_top();
  string s;

  initial begin
    check_anagram();
    disp_fun();
    disp_task(); // for merge conflict
  end

  function void check_anagram();
    string str1, str2;
    str1 = "listen";
    str2 = "silent";
    if (is_anagram(str1, str2)) begin
      $display("%s and %s are anagrams.", str1, str2);
    end else begin
      $display("%s and %s are not anagrams.", str1, str2);
    end

    str1 = "hello";
    str2 = "world";
    if (is_anagram(str1, str2)) begin
      $display("%s and %s are anagrams.", str1, str2);
    end else begin
      $display("%s and %s are not anagrams.", str1, str2);
    end
  endfunction: check_anagram

  function void disp_fun();
    $display("Testbench completed.");
  endfunction: disp

  task disp_task();
    $display("This is a display task.");
  endtask: disp
endmodule: tb_top