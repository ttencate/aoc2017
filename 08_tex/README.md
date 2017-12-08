# [Day 8](http://adventofcode.com/2017/day/8) in TeX

Linear execution, just a few conditionals and variables, straightforward input
format, no complex logic... this sounds like a perfect job for TeX! Heck, it
even has "registers".

And TeX can read from stdin just fine, if you just `\openin1=/dev/stdin`. This
will let you read the file line by line using `\read1 to \currentline`. Using a
recursive macro `\readlines` containing an `\ifeof1` check, it's surprisingly
straightforward to read until end-of-file. For kicks, or actually because
Knuth's TeXbook told me to, I did this in a tail-recursive way, so it should be
efficient even for large inputs.

To parse each line I defined a macro `\parseline` like this:

    \def\parseline#1 #2 #3 if #4 #5 #6 {...}

Normally you'd write `#1#2#3...` all without spaces, but the general definition
is actually more versatile, and works a lot like pattern matching. We have to
invoke it like this:

    \expandafter\parseline\currentline

The `\expandafter` will expand `\currentline` to the actual line's contents
before proceeding with the expansion of `\parseline`. The effect is that
`\parseline` sees the arguments in the format it expects, and all is great.

The next step was to store register values somehow. TeX has registers, but they
are numbered, not named. But we can pull another trick: using `\csname foobar
\endcsname`, an arbitrary sequence of characters can be turned into a `\foobar`
token. This lets us define macros `\regfoobar` which expand to that register's
current value. Easy peasy.

Actually, the harder part was to get all conditionals right. Somehow, `\ifx`
(which tests two... things for... some form of equality) would never do what I
wanted or expected. But eventually I beat it into submission with lots of
auxiliary macros.

The final step was to enumerate all registers and extract the maximum. For
this, I first needed to have a list of all of them. Easier said than done,
because appending to a macro without hitting infinite recursion is not trivial,
but eventually I got it to work. I now had a `\registers` macro that expanded
to all register names, each terminated by a `,` character.

To iterate over that list, I used another tail-recursive macro with the
following signature:

    \def\findmax#1,{...}

Note the comma? Actually TeX macros can do a sort of primitive pattern
matching. This one will gobble up all tokens until it finds a comma, and then
expand. As the final token in its expansion, it will produce a `\findmax`
token, which is ready to consume the next sequence of tokens. Nifty, eh?

The rest of it was some more simple arithmetic. As a bonus, you receive a
nicely typeset `.pdf` file with debug output!

---

I was terrified that the second part would have me do something
near-impossible, so I was happily surprised that all I needed to do was keep a
running maximum. It was actually even easier than the first part!
