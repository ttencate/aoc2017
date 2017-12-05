128 constant max-line
create line-buf max-line chars allot

: read-number ( c-addr length -- c-addr' length' value )
  0. ( c-addr length value-d )
  2swap ( value-d c-addr length )
  >number ( value-d c-addr' length' )
  1 - swap 1 + swap \ skip the tab
  2swap ( c-addr' length' value-d )
  d>s ( c-addr' length' value )
;

: compute-max-min ( max min value -- max' min' )
  rot ( min value max )
  over ( min value max value )
  max ( min value max' )
  -rot ( max' min value )
  min ( max' min' )
;

: compute-max-min' { maxv minv value -- max' min' }
  maxv value max
  minv value min
;

: line-max-min \ parses the line and computes the min and max ( c-addr length -- max min )
  0 99999999 2swap ( max min c-addr length )
  begin
    dup 0 >
  while
    read-number ( max min c-addr length value )
    4 roll ( min c-addr length value max )
    4 roll ( c-addr length value max min )
    rot ( c-addr length max min value )
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
