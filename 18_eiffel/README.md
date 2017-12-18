# [Day 18](http://adventofcode.com/2017/day/18) in Eiffel

Eiffel is an object-oriented language whose key selling point is Design by
Contract. Every method you write can have explicitly stated preconditions and
postconditions, and you can have class invariants and loop (in)variants as
well. Presumably all these are checked at runtime, but I'm not sure.

Several Eiffel implementations exist. For my purposes, Liberty Eiffel seems to
be the most suitable: not too old and crusty, and available for Linux. I had to
compile from source, because (unlike the Eiffel Studio IDE) no Arch Linux
package exists even in the AUR. The home-grown compilation script took a long
time, because it only uses one CPU core. And then I accidentally ran the
compile script again, and it removed all the output. Maybe I'll finish my code
in the meantime…

To get to know the language, I had expected an article like "The Tour of
Eiffel" to exist. And there is
[something](http://wiki.liberty-eiffel.org/index.php/Tutorial_tour) that's
almost it, but entirely not it. Missed opportunity. So I'll have to make do
with lesser named tutorials like
[this one](https://www.eiffel.org/doc/eiffel/An%20Eiffel%20Tutorial%20%28ET%29),
and my trusty companion
[Rosetta Code](http://rosettacode.org/wiki/Category:Eiffel).

I have some time today, so rather than writing this as if it were C, I'll
embrace the Eiffel way and try for some idiomatic code. We'll have an abstract,
ahem, `deferred` class `INSTRUCTION` (Eiffel is case insensitive, but class
names are traditionally in all-caps), which is inherited from by the different
instruction types. Each instruction type implements a method `execute` which
takes a `STATE` object and possibly modifies it. (Were this a functional
language, I'd opt for returning a new `STATE`, but here it'll just be more
boilerplate.)

While writing this, one thing that stood out to me time and time again was the
quality of the Liberty Eiffel compiler errors. They are rather verbose, but are
very clear and helpful. It sets a great example for other compiler writers to
follow. An example:

    ****** Fatal Error: Cannot pass `program.upper' which is of type INTEGER_32
    into formal type INSTRUCTION.

    The source lines involved by the message are the following:

    Line 34 column 29 in AOC18A (aoc18a.e):
            program.put(program.upper, parse_instruction(std_input.last_string))
                                ^
    Line 195 column 18 in ARRAY (eiffel/src/lib/storage/collection/array.e):
       put (element: like item; i: INTEGER)
                     ^

The stack traces coming out of contract failures at runtime are equally useful:
not only do they show you the stack itself, but they also print the values of
all local variables in each stack frame. This is often enough to pinpoint the
bug without needing to break out a debugger.

I'm using the design-by-contract features to handle parse errors too. I'm not
sure whether or not this is idiomatic, but it is convenient. From a cursory
glance, it seems that return codes or setting class fields would be more
idiomatic.

---

Part Two
