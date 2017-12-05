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

\ quotient is a/b or b/a if either divides cleanly, 0 otherwise
: dividing ( a b -- quotient )
  2dup < if swap endif
  2dup mod 0 = if
    /
  else
    2drop 0
  endif
;

: check-dividing ( values... count v -- values... count quotient )
  \ iterator goes from count-1 down to 0
  over 1 - ( values... count v iter )
  begin
    dup 0 >=
  while
    dup 3 + pick ( values... count v iter w )
    2 pick ( values... count v iter w v )
    dividing ( values... count v iter quotient )
    dup 0 > if
      nip nip ( values... count quotient)
      exit
    endif
    drop ( values... count v iter )
    1 -
  repeat
  2drop 0 ( values... count 0 )
;

: dropn ( values... count -- )
  begin
    dup 0 >
  while
    nip
    1 -
  repeat
  drop
;

: line-dividing ( c-addr length -- quotient )
  0 rot rot ( count c-addr length )
  begin
    read-number ( values... count c-addr length v )
    -rot ( values... count v c-addr length )
    2>r ( values... count v )
    dup >r
    check-dividing ( values... count quotient )
    dup 0 > if
      rdrop 2rdrop ( values... count quotient )
      >r ( values... count )
      dropn ( )
      r> ( quotient )
      exit
    else
      drop r> swap 1 + ( values... v count' )
      2r> ( values... count c-addr length )
    endif
  again
;

: main
  0 ( acc )
  begin
    \ read a line into line-buf ( -- length )
    line-buf max-line stdin read-line throw
  while
    \ dup line-buf swap dump \ print current buffer
    line-buf swap line-dividing ( acc quotient )
    + ( acc )
  repeat
  drop ( acc length -- acc )
  .
;
main

max-line negate chars allot
