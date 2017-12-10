# [Day 10](http://adventofcode.com/2017/day/10) in J

_Here's the start of an incomplete solution in J. The J language is a very
interesting puzzle, but I ran out of time._

So, today is the day I try the
[J programming language](https://en.wikipedia.org/wiki/J_%28programming_language%29).
It was designed by the creator of APL, so I would expect to see many of the
same ideas (whichever those are), but with the advantage of not having to buy a
[dedicated keyboard](https://duckduckgo.com/?q=apl+keyboard&t=ffab&iax=images&ia=images).
I'm seeing lots of people using J for code golf, resulting in extremely terse
code [like this](https://codegolf.stackexchange.com/a/148196/3319):

    0=10|1#.(8$3 1)*]

These people seem to use some online interpreter, but I'm going to stick with
my own rules and read from stdin. So I grabbed the J source code (GPLv3) from
https://github.com/jsoftware/jsource and looked at `overview.txt`. It has some
instructions on building and installing this stuff. It's a ridiculous build
system with homegrown shell scripts and files that need to be copied to
specific locations in your home directory, but OK, I'll bear with it.

After sourcing the environment shell script `~/jvars.sh`, I find that `$j64`
(yes, a variable... why not a shell alias or simply a `PATH` update?!) gives me
a kind of REPL. Although it refuses to do `--help` or `-h`, it seems I can pass
it a filename on the command line, and it'll execute that script. Subsequently,
it also decides to go ahead and parse and execute stdin. Fun times.

On to actually learning a bit of the language. There is a
[cheat sheet](http://code.jsoftware.com/wiki/NuVoc) containing all the magical
symbols, but it's a bit cryptic. Worth noting is that operators ("verbs" in
J-speak) can be used either monadic (with one argument) or dyadic (with two
arguments), and they may do completely different things. Monadic verbs are
written prefix, dyadic ones infix, and general order of execution is from right
to left:

       2*3+1
    8

I'm gathering some building blocks first. I can generate the initial list with
`i.256`, which uses [`i.`](http://code.jsoftware.com/wiki/Vocabulary/idot) to
produce a list of ascending integers:

       i.10
    0 1 2 3 4 5 6 7 8 9

The [`|.` verb](http://code.jsoftware.com/wiki/Vocabulary/bardot) reverses a
list:

       |.i.10
    9 8 7 6 5 4 3 2 1 0

Grabbing a subarray and reversing it in one go can be done with
[`];.0`](http://code.jsoftware.com/wiki/Vocabulary/semidot0#dyadic), if you
pass a negative length (`_4`, because `-` is for mere mortals, not J gods):

       (7 ,: _4) ];.0 i.10
    9 8 7

Notably, [`@:`](http://code.jsoftware.com/wiki/Vocabulary/atco) performs
function composition; a space (like it would be in Haskell) is a
[hook](http://code.jsoftware.com/wiki/Vocabulary/hook) instead which I don't
quite follow.

[`>:`](http://code.jsoftware.com/wiki/Vocabulary/gtco) is increment:

       >: 5
    6

And [`|`](http://code.jsoftware.com/wiki/Vocabulary/bar#dyadic) is modulo:

       12|5
    5

Finally, on the topic of reading input, I stumbled upon
[J for C programmers](http://www.jsoftware.com/help/jforc/input_and_output.htm#_Toc191734418)
which pointed me in the right direction; finally, I found out about
[`1!:1 3`](http://code.jsoftware.com/wiki/Vocabulary/Foreigns#m1) which will
read from stdin. This input can be parsed with
[`".`](http://code.jsoftware.com/wiki/Vocabulary/quotedot) which is basically
"eval". We just need to lop off the trailing newline using
[`}:` (curtail)](http://code.jsoftware.com/wiki/Vocabulary/curlyrtco).

Now... I could do a loop to process each input item in order. But that goes
against the grain of the language. So let's try a more functional style
instead. The structure is essentially a fold, where our "state" (items which we
are folding over) are tuples `(current_position, current_list)`. Representing
tuples in J is a bit inelegant (read: I don't really know how), so we can do
this another way: just use `current_list` as the state, and keep track of our
current position using a global variable.

So we construct a dyadic verb `x step y`, where `x` is the current list, and
`y` is the next number from the input. Then we fold it using
`step/ i.256,input`, where `i.256,input` is a heterogeneous list whose first
element is the state, and the rest are the steps to be taken. Except it's not
that simple, because this just concatenates the two arrays. We need to box the
first as a whole, and box the items of the second individually:

       (<(i.5)) , ;/ input
    ┌─────────┬──┬──┬─┬───┬───┬──┬───┬─┬───┬───┬──┬──┬───┬───┬─┬───┐
    │0 1 2 3 4│34│88│2│222│254│93│150│0│199│255│39│32│137│136│1│167│
    └─────────┴──┴──┴─┴───┴───┴──┴───┴─┴───┴───┴──┴──┴───┴───┴─┴───┘

Incidentally, this display of the output is one of the few things I really
like about J. If you get output, it's very readable. If you get an error
though, it doesn't tell you much more than "syntax error".

---

Part Two

Conclusion: this language is bonkers. Its main selling point is "array
processing", but one can do parallel operations on arrays in many other
languages with less cryptic syntax, like Python with numpy, or Matlab/Octave.
