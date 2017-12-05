# [Day 3](http://adventofcode.com/2017/day/3) in TCL

My first TCL code. But serious applications are (were?) being
written in this language not so long ago, so how bad can it be?
Either way it's just a bit of arithmetic, no fancy data
structures like arrays required.

Just browsing through the excellent
[TCL tutorial](http://www.tcl.tk/man/tcl8.5/tutorial/tcltutorial.html),
the language reminds me a lot of bash. I hope it doesn't do the crazy
whitespace stuff bash does, but it shouldn't matter for this puzzle.

A naive solution would be to walk the spiral until we reach the target
number, then check where we are. A less naive solution is to grow the
field one square "shell" at a time, until it includes the input; then
figure out where in the edge of the shell we are. An optimal solution would be
not to enumerate the shells at all, but compute the right shell analytically
with a floored square root.

I chose the second solution, because it should be fast enough even if Part Two
ups the ante, is easier to debug, and has less potential for off-by-one errors.

---

For part two, actually the naive spiral walking solution would have been more
useful. Time for a rewrite. The coordinate system from the first part came in
useful after all.
