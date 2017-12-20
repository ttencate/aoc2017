# [Day 20](http://adventofcode.com/2017/day/20) in Nim

Looks like we have another open-ended simulation on our hands today. With 1000
particles, I'll pick a statically typed, compiled language today: Nim. Nim
(formerly Nimrod) is supposed to be syntactically similar to Python, and well
liked by its users, so I hope this will be interesting.

First question: can we solve this analytically, to avoid simulating _n_
particles over _k_ time steps? Not easily, I think. The trajectory of each
particle is a parabola, so it's easy to express it in closed form, and easy to
find its minimum. But the distance to the origin (even in 1D) is more
complicated, because we're using the Manhattan distance rather than Euclidean
distance. Even in 1D, this means the distance can have three different minima
(one from the top of the parabola, and two from its zero crossings), and in
general these won't correspond to minima in 3D. Furthermore, the minima might
occur between two time steps, but we're only looking at integers here.

Second question: when do we stop? Were I competing for the leaderboards, I'd
just set it to print minimum distances and wait until the value stops changing,
but let's try for something more correct. We can't simply stop after each
particle has passed a minimum distance to the origin. A particle can come close
to the origin, zoom around, and come back even closer. But one guarantee we
have is this: if position, velocity and acceleration all have the same sign (in
each dimension separately), it will only get further away. So this is the point
where we can kill that particle.

So that's the plan. Let's write some code. Installing the Nim compiler is easy;
there's an Arch Linux package. Reading input is literally the first example in
the [tutorial](https://nim-lang.org/docs/tut1.html), convenient! Seems I need
to handle an `EOFException` to deal with the end of the file; a bit Pythonic
indeed. But wait, isn't there an iterator construct as well? Why, yes:
`for line in lines(stdin)` works perfectly.

Nim doesn't have methods that "belong" to a class; everything is a free
function, although `obj.method(args...)` can be used as syntactic sugar for
`method(obj, args...)`. This means you get "extension methods" for free, so,
for instance, the `regexp` module can define a method `match(String, RegExp)`
"on `String` objects". Information hiding is done on the module level, not the
class level, just like in Go. Polymorphism is achieved by declaring your free
functions as `method` instead of `proc`, which makes overload selection happen
at runtime instead of compile time.

[Multiple dispatch](https://en.wikipedia.org/wiki/Multiple_dispatch) is
sneakily also supported in this way – a feature that's missing from (nearly?)
all mainstream languages. One example where this is useful is if you're
computing collisions between different types of shape (circle, rectangle,
line), so you need a different algorithm depending on the type of _both_
shapes. Multiple dispatch is not often needed, but when it is, it's a pain to
have to work around it.

On with the puzzle. For parsing each line, I could just split it on commas, or
use a regular expression, but let's try something fancier instead: Nim's
built-in [`pegs` module](https://nim-lang.org/docs/pegs.html) for parsing
expression grammars. It lets you parse things by writing an EBNF-like grammar
for them. Pretty cool! Sadly, you don't get a real AST out of it, just a flat
array of matched capture groups, limited to 20 entries. So for parsing a full
programming language, this may be a bit limited.

After parsing, we just need to do the simulation and keep track of the global
minimum, eliminating particles as soon as they can no longer get any closer to
the origin. You might have guessed by now that I'm a fan of functional
programming style, so some `map` and `filter` operations from the `sequtils`
module come in handy here.

At this point, I reread the assignment, and discover that I've been
misinterpreting it all along: the question is not which particle comes closest
to the origin ever, but which particle is the closest to the origin in the
limit situation `t → ∞`. Oops. In that case: it must be the one with the
smallest acceleration, measured by the L1 norm (Manhattan distance). And this
is much easier.

---

On to the second part: collision detection! I didn't see that coming. Now we
_do_ need to simulate, I suppose. Or do we…? Collisions are not based on
Manhattan distance, but on exact equality. So we _can_ solve this analytically,
by finding the collisions between each pair of particles in an O(_n_²) fashion.
As _n_ = 1000, this isn't too bad.

The position of particle `p` at time `t` is given by:

    pos(p, t) = p.p + p.v × t + p.a × t²

Particles `p` and `q` collide if and only if `pos(p, t) = pos(q, t)` for some
`t ≥ 0`. (I'm sure this latter condition is going to trip many people up if
they also count collisions in the past.)

Because this is an equality whose left and right side are both 3D vectors, we
need to find a `t` for which all three of them match. We can just find the (up
to two) `t`s for which this holds, per coordinate, using the
[quadratic formula](https://en.wikipedia.org/wiki/Quadratic_formula),
and checking that the answer is an integer. Having found the candidate times
for each coordinate individually, we do a set intersection on them. If the set
is nonempty, we've found a `t` at which a collision happens.

Finally, we need to be careful not to remove colliding pairs entirely, because
they might both collide with a third particle.

After getting this to compile, it crashed with an `OverflowError`. Turns out
(of course) that the difference in acceleration can sometimes be zero, resulting
in division by zero. In this degenerate case, we need to do an intersection of
two linear equations, rather than quadratic. Similarly, if the initial velocity
difference is also zero, we just test if the positions are equal. This is the
ultimate degenerate case: both particles have an identical `x` or `y` or `z`
coordinate _at all times_. I represented this as a `nil` sequence, to
distinguish it from an empty sequence.

While debugging this (because of course it's too complicated), I realised that
I was overlooking something else. When two particles are determined to collide,
we must also check whether both of them even still existed at that time! This
isn't impossible, but would involve storing all potential collisions in a list,
sort it by time, then run through it.

From my (admittedly buggy) debug output, I can see that times are rarely
greater than a few hundred or so. So a simulation is entirely feasible. And
that's what I ended up doing. Using a hash table for collision checks means we
don't have an O(_n_²) collision detection, but an O(_n_) one. And because the
right answer appears after 39 time steps already, we have done 1000 × 39
operations instead of 1000 × 1000, so it's actually pretty fast too.
