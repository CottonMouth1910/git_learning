module palindrome_checker;
  string test_string;
  logic is_palindrome;
  
  function logic check_palindrome(string str);
    int left, right;
    left = 0;
    right = str.len() - 1;
    while (left < right) begin
      if (str[left] != str[right]) begin
        return 0;
      end
      left++;
      right--;
    end
    return 1;
  endfunction
  
  initial begin
    test_string = "racecar";
    is_palindrome = check_palindrome(test_string);
    $display("String: %s | Is Palindrome: %b", test_string, is_palindrome);
    test_string = "hello";
    is_palindrome = check_palindrome(test_string);
    $display("String: %s | Is Palindrome: %b", test_string, is_palindrome);
    test_string = "level";
    is_palindrome = check_palindrome(test_string);
    $display("String: %s | Is Palindrome: %b", test_string, is_palindrome);
    test_string = "madam";
    is_palindrome = check_palindrome(test_string);
    $display("String: %s | Is Palindrome: %b", test_string, is_palindrome);
    test_string = "world";
    is_palindrome = check_palindrome(test_string);
    $display("String: %s | Is Palindrome: %b", test_string, is_palindrome);
    test_string = "a";
    is_palindrome = check_palindrome(test_string);
    $display("String: %s | Is Palindrome: %b", test_string, is_palindrome);
    test_string = "noon";
    is_palindrome = check_palindrome(test_string);
    $display("String: %s | Is Palindrome: %b", test_string, is_palindrome);
    $finish;
  end
endmodule