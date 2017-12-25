# Polyglot Advent of Code 2017: a retrospective

It's over! I finished! 25 programming puzzles in 25 different languages. And if
you include last year's: 50 programming puzzles in 50 different languages.

First off, a **huge** thank-you to Eric for making and running Advent of Code.
Once more, it's been a blast. If you liked it even half as much as I did,
consider [giving this guy some money](http://adventofcode.com/2017/support). He
deserves it.

I'm not going to write something about every day, because I already did that.
See the `README.md` files in the individual subdirectories in
[my repo](https://github.com/ttencate/aoc2017). Rather, I'll just pick the most
interesting experiences here.

Remember the rule I used: input must be parsed as-is from stdin if possible,
from a file named `input` otherwise.

### [Day 1: PostgreSQL](https://github.com/ttencate/aoc2017/tree/master/01_postgresql)

The main issue: making an SQL database server read from a file (stdin was a
non-starter). Turns out, PostgreSQL can actually do this! As long as you read
the docs closely, and put the input file in just the right location (root
privileges required).

### [Day 2: Forth](https://github.com/ttencate/aoc2017/tree/master/02_forth)

Forth is a stack-based language from the early '70s. Apparently it's still in
use in the space industry (of all places), and the MS-DOS game Starflight
(recommended!) was also written in Forth.

The stack-based paradigm isn't very popular anymore, and with good reason: code
is much easier to read if variables have names, rather than being anonymous
stack entries. Yet, Forth made for a good challenge and forced me to think
differently. Incidentally, I'm working on a programming game involving a
stack-based language, so it was good to have tried a "real" one.

### [Day 8: TeX](https://github.com/ttencate/aoc2017/tree/master/08_tex)

Suggested by
[a redditor](https://www.reddit.com/r/adventofcode/comments/7gu2ze/2017_25_more_languages_polyglot_aoc2017_a/dqnhek4/),
TeX is Donald Knuth's late '70s typesetting language, which underlies the more
well-known LaTeX. Despite being a typesetting language, not a "real"
programming language, it is actually Turing complete thanks to the availability
of conditionals and recursive macros. What's more, it can read files (including
`/dev/stdin`), and has some limited form of pattern matching for macro
arguments, which made it possible to process the input file entirely by the
rules.

And the best part: as a side effect, I got a PDF file with a beautifully
typeset debug log.

### [Day 9: Julia](https://github.com/ttencate/aoc2017/tree/master/09_julia)

Julia is a high-level language for numerical computing. My limited experience
with it on this one day has been very promising: a good self-documenting
library, good documentation, simple syntax. It's sort of a mix between Python
and Lua, with a few drops of Ruby thrown in. I don't know if it can oust Python
(and numpy) from this domain, but it's certainly a good contender.

### [Day 10: Erlang](https://github.com/ttencate/aoc2017/tree/master/10_erlang) and [Day 22: Elixir](https://github.com/ttencate/aoc2017/tree/master/22_elixir)

Erlang's main selling point is its magical highly concurrent runtime, where
programs run as independent "processes" that communicate via message passing.
The Go language has taken some inspiration from this, but hasn't taken it to
the extremes that Erlang has. For instance, if a process crashes, you can
arrange for it to be automatically restarted. And even neater: processes can be
hot-swapped to allow for updates without having to restart the entire VM.

The main drawback of Erlang is its unusual, and plain inconvenient, syntax.
For example, bindings are separated by `,`, function definitions by `.`, and
overloads of the same function by `;`. As a consequence, whenever you change
something, you have to sort out your punctuation again.

And this is where Elixir comes in. It's basically Erlang, but with more modern
and convenient syntax. Throw in a more consistent standard library, and you
have a great language based on a powerful platform, which I wouldn't mind doing
actual work in.

### [Day 11: J](https://github.com/ttencate/aoc2017/tree/master/11_j)

J is an oddball language. Rather than using English words to define its
standard library functions, it's entirely based around infix (binary) and
prefix (unary) operators, and there are
[tons](http://code.jsoftware.com/wiki/NuVoc) of them. Just to give you a taste,
here's how I read and parsed the input:

    input =: ((<, ',') & ~: # ]) ;: }: (1!:1) 3

Most operators have both an infix and a prefix version, and they do different
things. Some operators take another operator as argument, and modify its
behaviour. It's functional programming, condensed beyond the point of
usefulness. J is fantastic for code golf, or for impressing your programmer
friends, but not for much else.

### [Day 15: Pony](https://github.com/ttencate/aoc2017/tree/master/15_pony) and [Day 20: Nim](https://github.com/ttencate/aoc2017/tree/master/20_nim)

I'm lumping these together because Pony and Nim are both among those languages
(others being Rust and Go) that aim to be "a better C": statically typed,
compiled to machine code, high performance, memory safe, type safe, all other
kinds of safe.

Of the two, Pony is the most innovative: with its different types of reference
capabilities, it becomes possible to have an ironclad compile-time guarantee
that your concurrent program is free of race conditions and deadlocks. Nim is a
bit more conservative, with a Python-like syntax and no particularly
interesting concurrency mechanisms, but this does make Nim a bit easier to get
into. I found both very pleasant to work with.

### [Day 23: PHP](https://github.com/ttencate/aoc2017/tree/master/23_php)

Saved for one of the last puzzles, because _surely_ a language that so many
people are making so many products in can't be that bad? Think again. PHP has
only been "improved" over the years by bolting on more features, but none of
the existing problems have been fixed. Despite the existence of anonymous
functions, functional-style programming is still a pain. Basic functionality is
missing. And all the world is still in a single namespace. Even AoC creator
Eric Wastl [agrees that PHP is sad](http://phpsadness.com/).

## Conclusion

These were just the highlights. If you want to see whether your favourite
language was featured this year (or last), head over to
[the repo](https://github.com/ttencate/aoc2017) to see the full code with
commentary.

So what's in store for next year? Another fresh set of 25 languages? Unlikely.
I finished last year with a lot of languages I hadn't used yet, but this year
only 9 are left. I would have to dive into the _really_ obscure and esoteric
stuff to make it work yet another time, and I probably won't have time for
that. Maybe I'll just compete for the leaderboard instead – having to learn
about 16 new languages from scratch, I didn't stand a chance in 2017. Or maybe
I'll up the ante in some other way. Who knows?

Happy holidays everybody!
