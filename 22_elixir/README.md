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

As usual in functional languages, we need to keep the entire state in a value
(a tuple in this case), and have a function that takes a state and computes the
next one. Iterate this until done, and extract the answer. Simple.

---

For the second part, a simple set is no longer enough. We now need a map of
coordinates to state. The default state, clean, is represented as absence from
the map.

In conclusion: I was wrong, and Elixir is nothing like Ruby at all. It's just
Erlang with a more pleasant syntax. Which is exactly what the world needed!
