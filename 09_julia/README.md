# [Day 9](http://adventofcode.com/2017/day/9) in Julia

I was planning to use J today, but I can't find a readily installable package
for Arch Linux for it. So I'll save that for some other day when I have more
inclination to compile stuff from source. Instead, I'll use Julia. Also starts
with a J.

I don't know anything about Julia except that it is used for mathematical
computing. Looking at the [website](https://julialang.org/), it seems friendly
enough. Not that I'm going to be using any of its selling features here...

Julia has a friendly REPL, with a built-in help function. That's really
helpful! Its built-in `readline` function does exactly what I need for reading
the input, no fuss.

On to processing. Using a simple recursive parser, this should be pretty
straightforward. Julia's syntax is familiar and unsurprising, somewhat of a mix
between Ruby and Python. Arrays are indexed from 1, but I can live with that.
One problem I encountered was that my parsing functions couldn't access the
global variable `i` that I defined. I couldn't find a clear reason why, but
fixed it by adding a `global` declaration for them.

---

Part Two
