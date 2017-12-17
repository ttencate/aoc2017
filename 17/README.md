# [Day 17](http://adventofcode.com/2017/day/17) in BBC BASIC

I'm going to do something a bit special today. My first ever computer was the
BBC Micro (Model B), powered by BBC BASIC. The machine had 32 kB of RAM and ran
at 2 MHz. Which, I figured, should be enough to get through today's puzzle!
Part one, at least…

Unfortunately, my Beeb died on me a few years ago, so I'm going to be using an
emulator today. I installed the Linux port of BeebEm and tried to type `*.` (an
abbreviation for `*CAT`) to see if there was an emulated disk in the drive. But
apparently, BeebEm for Unix doesn't map the keyboard as nicely as the Windows
version, so it came out as `(.`. Eventually I found the `*` character under the
`'` key (which, to complicate matters further, is actually the `Q` key on my
keyboard because it's set to dvorak layout).

As a language reference, I'm using
[bbcbasic.co.uk](http://www.bbcbasic.co.uk/). It's actually a Windows
reimplementation of the language, but it should be close enough. I'm also using
[Rosetta Code](http://rosettacode.org/wiki/Category:BBC_BASIC).

I do try to stick to the rules, so I should either read the input from "stdin"
(the keyboard, because no input redirection exists on this OS), or from a file
named `input`. Typing the input (359) for each test run is both tedious and
overly simple, so I'll read from a file instead. But it must be a plain-text
ASCII file. I created it like this:

    >F%=OPENOUT("input")
    >PRINT#F%,"359"
    >CLOSE#F%
    >*TYPE"input"
    953

Huh? Well, it seems strings are stored backwards in a file, but reading them
back works fine:

    >F%=OPENIN("input")
    >INPUT#F%,A$
    >CLOSE#F%
    >PRINTA$
    359

There might be an invisible length byte preceding it as well. To write a string
verbatim, followed by a newline (ASCII 10), we need `BPUT#` instead:

    >F%=OPENOUT("input")
    >BPUT#F%,"359"

    Type mismatch
    >_

Hmm, seems that BBC BASIC for Windows isn't quite the same as the real thing
after all.
[Here](http://central.kaserver5.org/Kasoft/Typeset/BBC/Contents.html) is what
seems to be a transcript of the official BBC Micro User Guide, which should be
the canonical reference, and it makes no mention of `BGET#` supporting strings.
So let's do it by hand:

    >BPUT#F%,51
    >BPUT#F%,53
    >BPUT#F%,57
    >BPUT#F%,10

Next up: write code to read this file and parse the bytes back into an integer.

    >10F%=OPENIN("input")
    >20I%=0
    >30B%=BGET#F%
    >40IFB%=10THENGOTO70
    >50I%=I%*10+(B%-48)
    >60GOTO30
    >70CLOSE#F%
    >80PRINTI%
    >RUN
           359

By prefixing a statement with a line number, it becomes part of your program
instead of being executed immediately. Note how spaces are entirely optional.
Also note the use of `GOTO`: the `break` statement doesn't exist here. Integer
variables can be suffixed with `%`, which makes them a bit faster and
memory-efficient.

On to the actual puzzle. Arrays need to be dimensioned up front, so we just
create one that's big enough and keep track of how many elements are used.
Arrays are zero-indexed, but they include the upper bound, so `DIMB%(2017)`
actually gives us a 2018-element array, just as we need. To find the next
index, of course we use the `MOD` operator instead of stepping 359 times.

    80DIMB%(2017)
    90A%=0
    100FORS%=1TO2017
    110A%=((A%+I%)MODS%)+1
    120FORJ%=S%TOA%+1STEP-1
    130B%(J%)=B%(J%-1)
    140NEXTJ%
    150B%(A%)=S%
    160NEXTS%
    170PRINTB%((A%+1)MODS%)

This being a quadratic-time algorithm due to the slow insertions, it would have
taken a while to run on a real Beeb. Fortunately, I can crank up the emulator
speed to 100×; I don't know if it achieves that, but it did make the program
finish in under a minute. I wonder if a linked list would be more efficient: on
the one hand, insertions are constant-time, but on the other hand, we'd need to
traverse half the list on average to find the next insertion point. The big-O
doesn't care, but the machine might. Cache efficiency wasn't really a thing
yet, and maybe memory reads are faster than writes so the read-heavy linked
list implementation comes out ahead of the write-heavy?

---

Part Two
