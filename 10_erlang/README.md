# [Day 10](http://adventofcode.com/2017/day/10) in Erlang

After doing tomorrow's puzzle in J, going back to even a somewhat quirky
language like Erlang feels like a breath of fresh air. I've never actually
written any Erlang before, but I like its notion of processes and its approach
to robustness. It reminds me a bit of Go, although of course Erlang was first.

In fact, I always thought Erlang was a procedural language, but it seems like I
was mistaken: it has much more in common with functional languages than with
procedural ones. For instance, there's powerful pattern matching, most looping
is done using recursion or higher-order functions, and variables can't be
reassigned.

To remain true to the Erlang spirit, I'm going to implement this puzzle as a
bunch of numbered processes, where each process holds one item of the list.
They do all the work by passing messages between them.

After reading the input (straightforward for a change), we create all the
processes. Any process needs to be able to send its value to any other process,
so we pass the entire list of pids to all processes. They store this as a
function argument, as is common in functional languages.

Then the fun part: for input value, we send it to all processes. The process
inspects the value, and if it's in the range to be swapped, it sends its
current value to the appropriate destination process. If it's not in the range
to be swapped, it just sends it to itself (we could probably skip this). Next,
the process receives its new value from itself or one of its colleagues. If it
receives a special `report` message (sent from the main process), it responds
with its current value and exits.

The main process, after sending out all the input, simply sends `report` to
processes 1 and 2 (lists are 1-based in Erlang), waits for two answers,
multiplies them and prints the result.

---

Part Two
