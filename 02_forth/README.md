# [Day 2](http://adventofcode.com/2017/day/2) in Forth

[Forth](https://en.wikipedia.org/wiki/Forth_(programming_language) is a
concatenative (stack-based) language developed in the 70s. I've never used such
a language before, so this will be interesting. For implementation, I'm using
GNU Gforth.

References I used:

* The [Gforth manual](http://www.complang.tuwien.ac.at/forth/gforth/Docs-html/).
  It takes some getting used to, but most of what you need to know is there.
* [Rosetta Code](http://rosettacode.org/wiki/Forth). Brilliant. Not sure if I
  knew about this site last year...

As is often the case, figuring out how to read the input is a relatively big
hurdle. It needs memory allocation that is not on the "regular" stack, nor on
the return stack, but on yet another stack (although equivalents of `malloc`
and `free` also exist). A fixed size buffer will do for now, and we have a
sequence of bytes in memory and the length on the stack.

Then I tackled the overall structure. There should be a function ("word" in
Forth parlance, although word is broader) to compute the min and max of a line.
To make it easier for the caller, these will be returned in the order `max min`
(top of the stack is always on the right in this notation), so we can just
write `-` to find the difference and finally `+` to add it to the accumulator,
which should be on the stack before. In pseudo-Forth; the bit in parentheses is
always a comment that shows the current top of the stack:

    0 ( acc )
    \ for line in lines
      read-line ( acc line-length )
      parse-line ( acc max min )
      - ( acc max-min )
      + ( acc )
    \ endfor

While writing and debugging this, `.s` is a godsend: you can plop it anywhere,
and it simply prints the current stack. Printf debugging at its finest. Also
`dump` is handy for dumping the contents of a memory buffer, both in hex and in
ASCII.

For parsing, `>number` seems like the right word. Complication: it uses a
"double" (two stack cells) for input and output, which together represent one
large integer. `s>d` and `d>s` can be used to convert back and forth between
singles and doubles, but mainly the trick is to keep all stack operations
straight. Doubles are the reason that several stack operations come in a `2`
variant, like `2swap` and `2tuck`.

Finally, the most Forthy bit I wrote was the `compute-max-min` word, which updates the current maximum and minimum:

    : compute-max-min ( max min value -- max' min' )

It's full of lovely stack manipulations. For fun, I also wrote a much more
readable two-line version using "locals" (which pop cells from the stack and
binds them to local names).
