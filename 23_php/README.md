# [Day 23](http://adventofcode.com/2017/day/23) in PHP

Finally, we've reached the point where I can use languages I actually know! Or,
in PHP's case, knew. Around version 3 or so is where I left it. But I'm sure
one can still write horrible code in it, which is exactly what I need.

Apparently PHP has advanced since then, so I'm going to try storing the
instructions not as strings, nor as classes, but as functions bound to their
arguments.

This turns out to be harder than needed. Functions and anonymous functions
("closures") are not the same thing. To bind a regular function to some
arguments, you have to wrap it into an anonymous function and tediously repeat
all arguments. To get around this, I declared all functions I wanted to bind as
anonymous straight away. This also involved changing all call sites, because
you have to write `$my_func()` instead of `my_func()`. Also, closures don't
close over their outer scope automatically; you have to declare `use ($foo)` if
you want to use `$foo` from an outer scope. If you also want to modify it, you
have to write `use (&$foo)`, otherwise assignments to `$foo` from within the
function stay within the function, and you get hilarious bugs like the program
counter not incrementing (true story). This is similar to C++ lambdas, except
worse because you can't say "just use everything by default". Finally, there is
no `bind()` function, just more anonymous functions! So I wrote that one
myself.

---

Part Two
