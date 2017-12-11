# [Day 11](http://adventofcode.com/2017/day/10) in J

I tried to do yesterday's puzzle in J, but it took me a long time to get to
grips with this rather different language, so didn't have time to complete it.
I think it's faster to do today's in J instead, and then do yesterday's in
another language. If you want to see my J attempt for Day 10, dive into the Git
history.

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

It's worth noting that J is not a functional programming language, in the sense
that verbs are not values that can be passed around. The distinction between
verbs and nouns (values) is hard-wired into the parser. There are higher-order
verbs, "adverbs", which modify verbs — I have to admit the terminology is
growing on me – but I'm not sure how far their power reaches.

I'm gathering some building blocks first.
[`@:`](http://code.jsoftware.com/wiki/Vocabulary/atco) performs function
composition. A space between two verbs is a
[hook](http://code.jsoftware.com/wiki/Vocabulary/hook) instead which I don't
quite follow yet, but might be useful. Two spaces, as in `f g h`, is a
[fork](http://code.jsoftware.com/wiki/Vocabulary/fork), where `(f g h) x` is
equivalent to `(f x) g (h x)`. These might help me write this program in a
nice, compact, point-free, entirely inscrutable style.

The [`/`](http://code.jsoftware.com/wiki/Vocabulary/slash) adverb ("insert") is
used to fold a dyad over a list. For example, `/+` would be "sum".

[`>:`](http://code.jsoftware.com/wiki/Vocabulary/gtco) is increment:

       >: 5
    6

Finally, on the topic of reading input, I stumbled upon
[J for C programmers](http://www.jsoftware.com/help/jforc/input_and_output.htm#_Toc191734418)
which pointed me in the right direction; finally, I found out about
[`1!:1 3`](http://code.jsoftware.com/wiki/Vocabulary/Foreigns#m1) which will
read from stdin.

I'm going to stop describing all operators from here on; look at the source and
the NuVoc table if you want to follow along in detail. The essence is: read the
input into a string, tokenize it into words, and throw out the commas. Then
turn each directional string into a "step" array like `1 0`, sum up all the
steps to find the position, then apply some simple arithmetic to find the
distance.

My coordinate system has the y axis running to the north, and the x axis to the
northeast. On an infinite grid, this is much more convenient than a "staggered"
coordinate system. For more on hex grid coordinate systems, see
[Amit Patel's excellent blog](https://www.redblobgames.com/grids/hexagons/#coordinates).
To find the distance between two hex cells, consider the number of x steps (nw,
ne, sw, se) first. This is always exactly equal to the x distance, because a y
step doesn't affect the x distance, and it never makes sense to take both
positive and negative x steps (a single y step would be shorter). But we have a
choice with these x steps: northish or southish? We try to get as close to the
target as possible, and then continue with y steps. I worked that bit out with
pen and paper though.

---

Onwards to the second part! Computing the entire path is a one-character
change: `\` combined with `/` will compute cumulative sums. Then I just need to
write that verb that I was too lazy to make before, to take an `x y` position
and output the distance, depending on the "hexant" the position is in.

Conclusion: the J language is bonkers. Its main selling point is "array
processing", but one can do parallel operations on arrays in many other
languages with less cryptic syntax, like Python with numpy, or Matlab/Octave.
Also, its name is virtually ungoogleable, so you're stuck with browsing the
wiki until you find what you need. Search on the wiki is useless too, unless
you know the J terminology for what you want, but this is almost always
different from other languages' terminology. However, although I wouldn't use J
for anything practical, it did provide an interesting and mind-warping exercise.
