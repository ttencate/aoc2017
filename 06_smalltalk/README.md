# [Day 6](http://adventofcode.com/2017/day/6) in Smalltalk

Another first for me, Smalltalk is one of those languages that influenced
modern-day languages (most notably Java) but doesn't seem to be widely used
anymore, although it's still
[very well loved](https://insights.stackoverflow.com/survey/2017#technology-most-loved-dreaded-and-wanted-languages)
even today, so I suppose I'm in for something good.

I'm going to be using GNU Smalltalk-80. The
[tutorial](https://www.gnu.org/software/smalltalk/manual/html_node/Tutorial.html#Tutorial)
is excellent. There are many more implementations, like Squeak, Pharo and
Smalltalk/X, but GNU Smalltalk might be the least modern and therefore the most
historically interesting. No idea, really.

Conceptually, Smalltalk indeed strongly resembles Java, with a
single-inheritance class hierarchy. The most obvious difference is syntax:
where in Java, you would write `object.method(argument)`, in Smalltalk this is
`object method: argument` (actually, that's more like named arguments, but the
names of the arguments also indicate the method which gets called). Also,
statements are (very sensibly!) terminated with a `.` rather than a `;`. Unlike
Java, everything is an object (yay!); there are no primitive types which sit
outside the class hierarchy.

The core language is so minimalistic that basic control structures like `if`
and `while` are missing. These are instead implemented as methods on booleans
or blocks (anonymous functions), reminiscent of Ruby. (Indeed, Ruby seems to
have borrowed a lot from Smalltalk.) For example:

    0 to: 99 do: [ :i | (99 - i) print. ' bottles of beer on the wall' printNl. ]
    isRaining ifTrue: [ bringUmbrella ] ifFalse: [ wearShorts ]

This block concept allows for higher-order functions, which result in very
compact and readable code. I'm beginning to see why people like this language.

On to solving the problem. It's a simple matter of simulating, and tracking the
states we've seen. Smalltalk's `Set` class accepts any type as members,
including arrays, and comparisons are done properly (by value, not reference),
making life easy. As long as you remember that elements are actually _added_ by
reference, so you'd better not modify them afterwards. Which took me
embarrassingly long to realise.

---

For the second part, we need to track when a state was first encountered. A
`LookupTable` is perfect for this.
