# [Day 5](http://adventofcode.com/2017/day/5) in ALGOL

Previously, COBOL was the oldest programming language I had used, and that
wasn't an experience worth repeating. But today I'm going to go one year
further back, to 1958, and write this jump table thing in ALGOL. ALGOL 68, to be
precise, in the [Algol 68 Genie](https://jmvdveer.home.xs4all.nl/algol.html)
implementation. It seems that the ALGOL language has been very influential on
modern-day languages, so maybe it will be somewhat familiar.

Because machines back in the day had wildly different character sets, ALGOL
programs can look syntactically different depending on the flavour
("stropping") they use to indicate keywords. Possibilities include:

* quoted: `'for'`,
* dotted: `.FOR`,
* uppercase: `FOR`,
* bold: **`for`** (I'm not sure if this is used in machines or just on paper).

I'm using uppercase style ("upper stropping") here.

ALGOL reminds me a bit of Pascal: semicolons to separate, rather than
terminate, statements (boo!), and  `:=` for assignment and `=` for equality
testing (yay!). The data types remind me of C, with prefixes like `long long
real`; and there is even a lovely shorthand `+:=` operator. Array types
("multiples") are declared like `[]INT`, which has come back into style with
Go. And, unlike much newer languages like C, ALGOL is memory-safe. And every
sequence of statements ("units") is itself an expression, a concept which has
found its way into languages like Ruby.

But some things are new and interesting. Identifiers may contain spaces, which
I imagine can make programs easy to read but hard to parse. Rather than being
entirely strongly or weakly typed like most languages nowadays, things in ALGOL
can be softly, weakly, meekly, firmly and strongly typed, depending on context.
I'm not sure what that means but I love it already. What we would today call
"types" are referred to as "modes". All values are constant; in order to have a
"variable", you need to declare a _reference_ to a constant (because references
themselves can be mutated).
Reading decimal numbers from stdin is
[shown on Rosetta Code](https://rosettacode.org/wiki/Input/Output_for_Pairs_of_Numbers#ALGOL_68)
and not actually difficult (unlike COBOL).

---

Part Two
