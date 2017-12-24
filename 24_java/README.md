# [Day 24](http://adventofcode.com/2017/day/24) in Java

I don't think the Java language needs an introduction. It's dull, but solid,
and it gets the job done.

As I didn't immediately see a way to do this efficiently (e.g. dynamic
programming), I tried a simple recursive approach first. We store each
component twice in a `HashMap` of `ArrayList`s, indexed on the number of ports
on either side. The recursive algorithm simply flags a component as used,
enters the recursion, then unflags it again when done. This is less efficient
than removing the component outright, but saves the trouble of restoring it
at the correct index.

This worked fine, on the first try even.

---

The second part isn't conceptually different, but we need to judge bridges
based on a tuple of values now, rather than a single value. So I wrote a simple
`Metrics` class to carry both strength and length around.

This, too, worked fine on the first try.
