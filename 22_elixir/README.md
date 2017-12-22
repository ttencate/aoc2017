# [Day 22](http://adventofcode.com/2017/day/22) in Elixir

I don't know much about Elixir except that it runs on the Erlang virtual
machine, and has a Ruby-like syntax. Time to learn! From a cursory look at the
tutorial, the differences with Erlang are mostly syntactical, and the
underlying model is the same. Conveniently, I already wrote some Erlang for a
previous puzzle, so things are not entirely unfamiliar.

To represent the current state of the grid, the obvious solution is to use a 2D
array of booleans. However, we'd need to embiggen the array each time the
pointer steps out of bounds, which is tedious. It's much easier to maintain a
set of infected coordinates instead.

---

Part Two
