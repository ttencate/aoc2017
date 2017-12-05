128 constant max-line
create line-buf max-line chars allot

: compute-max-min ( max min value -- max' min' )
  rot ( min value max )
  over ( min value max value )
  max ( min value max' )
  rot ( value max' min )
  2 pick ( value max' min value )
  min ( value max' min' )
  rot drop ( max' min' )
;

: line-max-min \ parses the line and computes the min and max ( c-addr length -- max min )
  0 99999999 2swap ( max min c-addr length )
  begin
    dup 0 >
  while
    0. ( max min c-addr length value-d )
    2swap ( max min value-d c-addr length )
    >number ( ud1 c-addr1 u1 -- ud2 c-addr2 u2 ) ( max min value-d c-addr length )
    1 - swap 1 + swap \ skip the tab character
    2rot ( value-d c-addr length max min )
    2rot ( c-addr length max min value-d )
    d>s ( c-addr length max min value )
    compute-max-min ( c-addr length max min )
    2swap ( max min c-addr length )
  repeat
  drop drop ( max min )
;

: main
  0 ( acc )
  begin
    \ read a line into line-buf ( -- length )
    line-buf max-line stdin read-line throw
  while
    \ dup line-buf swap dump \ print current buffer
    line-buf swap line-max-min ( max min )
    - ( acc difference )
    + ( acc )
  repeat
  drop ( acc length -- acc )
  .
;
main

max-line negate chars allot
