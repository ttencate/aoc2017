# [Day 13](http://adventofcode.com/2017/day/13) in Octave

Some of my friends commented that they did today's puzzle in Matlab, so this
must be a great day to use Matlab's open-source cousin, Octave.

Reading input using `scanf` is delightfully simple, although it seems to read
all numbers into a flat list rather than just one line. Fine with me! Reshaping
that into two rows, and splitting them into separate matrices, is easy.

From there on, it's a simple matter of computing each scanner's period (which
is `2 * (depth - 1)`) and our arrival time at that scanner (which is simply
`depth`). If arrival time modulo period equals zero, we are caught by that
scanner. All these computations can nicely be done using matrix operations, no
explicit loops needed.

---

I had totally seen part two coming. (It was either this, or "compute the
minimum severity that can be achieved".) Here, a simple brute force solution
worked well on the example input, but takes a while to run on the real thing.
