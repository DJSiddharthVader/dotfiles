((comment) @header (#eq? @header "^#####+$"))
[
  "else"
  "while"
  "repeat"
  ; "##########"
  ; (header)
  (if_statement)
  (for_statement)
  (function_definition)
  (braced_expression)
  (parameters)
  (parenthesized_expression)
  (while_statement)
  (call
    function: (identifier) @function.call)
  (extract_operator
    rhs: (identifier) @variable.member)
  function: (extract_operator
    rhs: (identifier) @function.method.call)
] @fold
