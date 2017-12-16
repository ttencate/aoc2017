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
bit like a `|` pipeline in the shell. It actually feels fairly natural.

---

Part Two

I'm sure F# is a productive and practical language, but being a bit of a
C#/OCaml hybrid, it lacks the elegance of other functional languages. Sometimes
you invoke things as a function (`func object`), sometimes as a method
(`object.func`). Most values are mutable. There are different types of
sequences (`array`, `list`, `seq`) but no generic ways to process them (you
need to pick `Array.map`, `List.map` or `Seq.map`). And so on.
