# [Day 16](http://adventofcode.com/2017/day/16) in F#

This puzzle is practically begging to be solved in a functional language, using
algebraic data types, pattern matching and folds. Fortunately, we still have
one: F#, Microsoft's functional .NET language. The compiler is open source and
runs on Mono, and can be installed on Arch Linux through the AUR.

F# is an interesting take on the "functional language" concept, because it's
not nearly as pure as other functional languages like Haskell or Elm. Nor could
it be, because it uses the same underlying .NET library as C# does. I found the
[F# Tour](https://docs.microsoft.com/en-us/dotnet/fsharp/tour) to be a useful
resource in my quest. The
[F# Cheat Sheet](http://dungpa.github.io/fsharp-cheatsheet/) is a bit terser,
but equally useful.

I'm not entirely sure how function call syntax works in F# with multiple
arguments; sometimes separating them by spaces works, sometimes it doesn't. It
seems to be more idiomatic to chain function calls using the `|>` operator, a
bit like a `|` pipeline in the shell. It actually feels fairly natural. (Later
realization: probably functions are called with spaces, methods are called with
parentheses and commas.)

---

Second part! I had a feeling this was coming. Of course simulating 1000000000
dances is not great, so we need to be clever. Surely, after a certain number of
dances, the elements will end up in their initial state again, so we can cut
that loop short? The good news is, with 16 programs we can only have 16! =
20922789888000 different orderings... wait, that's not good news at all. My
next idea was to see where elements ended up after one full dance, which
reduces the entire dance to just one permutation... but this won't work either,
because the `Partner` operation depends on the identity of elements, not on
their position.

But! `Spin` and `Exchange` move elements irrespective of their identity, and
`Partner` moves elements irrespective of their position. So the two are
completely independent of each other, and actually commutative. So we can,
conceptually, perform all `Partner` operations first, and then all `Spin` and
`Exchange` operations, and we'll end up with the same result. And because a
`Partner` operation is just a permutation (of identities), and
`Spin`/`Exchange` are also just permutations (of positions), both must
eventually end up back where they started – within just a few dozen repetitions
or so. So within (a few dozen)² repetitions, we should find ourselves back in
the situation where we started. Despite the huge number of 16! _potential_
orderings, only a very small amount can actually be reached by repeatedly
applying the same two orthogonal permutations.

In conclusion: I'm sure F# is a productive and practical language, but being a
bit of a C#/OCaml hybrid, it lacks the elegance of other functional languages.
Sometimes you invoke things as a function (`func object`), sometimes as a
method (`object.func`). Most values are mutable. There are different types of
sequences (`array`, `list`, `seq`) but no generic ways to process them (you
need to pick `Array.map`, `List.map` or `Seq.map`). And so on.

To compensate for this brief rant, I'll leave you with
[this amazing song by Tim Minchin](https://www.youtube.com/watch?v=5Ju8Wxmrk3s).
