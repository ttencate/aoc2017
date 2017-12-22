# [Day 21](http://adventofcode.com/2017/day/21) in Icon

I'm saving my strongest languages for the last (and presumably most difficult)
puzzles, so today I'll have to make do with a lesser-known language called
Icon. According to the website, "Icon is a high-level, general-purpose
programming language with novel features including string scanning and
goal-directed evaluation." I don't expect any novelties, but it sounds like a
fine tool for the job.

The job at hand is to simply follow the rules and mechanically match the
patterns. But first, as usual, we need to read our input. And while reading the
patterns, I'm also going to store the flipped and rotated versions, to make
lookup simpler and more efficient.

Reading a line from stdin is simple: the `read()` function does exactly this.
Parsing it is done with `find()`. We store the mapping in a "table", which is
just a hashtable, dictionary, hashmap, or whatever you want to call it.
Incidentally, this isn't the only place where Icon reminds me of Lua. Which of
these languages came first, or whether one influenced the other, I don't know.

I don't suppose we can use arbitrary types for keys, so I'll just use the
slash-separated strings directly instead. I'll also use strings to represent
each grid row, because they seem to be easy to work with.

An interesting and unusual characteristic of Icon is its "goal-directed
evaluation". What does that mean? First, you need to know that many expressions
in Icon actually produce a _generator_, rather than a single value. The
expression evaluation mechanism then tries successive values from each
generator until a successful value for the entire expression is produced. For
example, `x | 5` is a generator that first produces the value of `x` and then
the value `5`, so `if y < (x | 5) then ...` only runs the `then` part if `y <
x` _or_ `y < 5`. If no success value can be found, the entire expression is
said to "fail". The expression evaluator actually uses a backtracking algorithm
to make this all work! [Here](https://www2.cs.arizona.edu/icon/intro.htm) is a
great introduction to it.

As an illustrative example of this style of programming, here's how I'm
splitting a string like `"##./#../..."` into a list of strings:

    parts := list()
    str ? while put(parts, tab(many('.#'))) do tab(upto('.#'))

The first part, `str ?`, means to use `str` as the "subject" of the rest of the
expression; many string operations then work implicitly with it. `many('.#')`
scans the subject while its characters match those in the input set, and
generates the index after this prefix. `tab` then sets this index as the new
starting point, and returns the substring, which is `put` onto the list. Then
the part after `do` is executed, which is used to skip the `/`. This repeats
until `many` fails to find a matching character at the current index in the
current subject.

Similar to `while`, there's also `every`, which evaluates all possible values
of an expression (essentially, the Cartesian product of all generators in the
expression). We can use this to join a list back into a string:

    str := ""
    every str ||:= "/" || !parts
    str := str[2:0]

Here, `!parts` generates all elements of the list `parts` one by one. `||` is
the string concatenation operator. At the end, we have to trim off the leading
`/`. I'm sure there's a better way to do all this, but hey, it works.

A consequence of this, plus the common "everything is an expression" paradigm,
means that – as far as I understand – procedure calls will silently be skipped
if one of their arguments fails. I'm not sure I like that. It makes programs
very hard to reason about, and hard to debug. Even your debug prints can fail
in this way!

---

Part Two

By the way, did you notice that the initial pattern is the
[glider](https://en.wikipedia.org/wiki/Glider_(Conway's_Life))?
