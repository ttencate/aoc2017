# [Day 25](http://adventofcode.com/2017/day/25) in Kotlin

I saved Kotlin for last, because it's my favourite language, and perfectly
suited for these kinds of puzzles. I'm going to use some Kotlin-specific
features to make the code look Really Nice™.

First, to parse the input. The easiest way to do this is iterate over the
lines, and apply a chain of regular expression matches to each line. But this
could get tedious, as we'd have to repeat it for all 7 types of input line:

    val match = Regexp("""...""").matchEntire(line)
    if (match != null) {
      ...
      continue
    }

We could make this snippet a bit more compact using `?.` and `apply`:

    Regexp("""...""").matchEntire(line)?.apply {
      ...
      continue
    }

The `?.` operator checks if its left side is `null`, and only invokes the
right-hand side if it's not. The `apply` extension method simply runs the
block, setting the `this` value inside the block to the thing it's being called
on (in this case, the `MatchResult` object).

The trouble with this is that the `continue` statement is no longer allowed
inside the block. If we assume that one and exactly one regex matches, that's
not a problem (apart from a slight performance hit). But I like to write my
code in such a way that it complains loudly if I messed it up, so I want it to
throw an exception if nothing matched.

Eventually I came up with this function:

    fun CharSequence.ifMatches(regex: String, fn: (MatchResult.Destructured) -> Unit): Boolean {
        val result = Regex(regex).matchEntire(this)
        if (result != null) {
            fn(result.destructured)
            return true
        }
        return false
    }

It's an extension function on `CharSequence`, so we can call this on `String`s.
We pass it the regular expression (uncompiled, for convenience). If it matches,
it invokes the given function, passing it the `destructured` match object.
Because of lambda argument destructuring, we can now give a name to each
capture group:

    line.ifMatches("""Say (.*) (\d+) times""") { (word, repetitions) -> ... }

Finally, the `ifMatches` function returns `true` if it matched, so we can use
the short-circuit behaviour of the `||` operator to chain these together and
finally throw an exception (because `throw` is also an expression in Kotlin):

    line.apply {
      ifMatches("""...""") { (foo) -> ... } ||
      ifMatches("""...""") { (bar) -> ... } ||
      throw RuntimeException("Could not parse line ${this}")
    }

With some more machinery behind the scenes (see the final code for details),
this can be made to look even nicer:

    line.matchRegexes {
      """...""" then { (foo) -> ... }
      """...""" then { (bar) -> ... }
    }

This is one of the main things I love about Kotlin: you can make up your own
DSL within the (quite flexible) Kotlin syntax, and there's usually a way to
make it work. Such tricks are often pulled in Ruby too, but in Kotlin it
requires far fewer hacks and is entirely verified at compile time to be type
safe.

---

Part Two
