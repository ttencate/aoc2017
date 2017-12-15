# [Day 15](http://adventofcode.com/2017/day/15) in Pony

This looks similar to a linear congruential generator, but instead of using
addition, it uses multiplication. It hasn't escaped me that 2147483647 is
2<sup>31</sup> - 1, and is a (Mersenne) prime. Neither 16807 nor 8921 is prime,
although the two numbers are comprime. But number theory isn't my strong suit,
so I don't know if these facts are at all helpful. From a quick check, the
matches appears to be scattered fairly randomly. So I guess brute force is what
we ought to be doing; and for 40 million numbers, I'd better pick a language
that isn't _overly_ slow.

"Pony is an open-source, object-oriented, actor-model, capabilities-secure,
high-performance programming language." OK, I don't need half of that, but
let's see how it compares to Python (PyPy solved this in 3 seconds). I tried
Pony on an earlier puzzle but got stuck on reading input; if needed, I can
cheat here and hardcode the two numbers.

Getting the Pony compiler up and running was easy thanks to some kind Arch
Linux user who made an AUR package that just installs from the official `.rpm`.
["Hello world"](https://tutorial.ponylang.org/getting-started/hello-world.html)
ran nicely.

On to reading input.
[This gist](https://gist.github.com/jemc/dff14f448faea7a922e4) has an example
of how to copy from stdin to stdout. It's... interesting. I suppose this is
async I/O? And what's with `be`, `fun tag`, `fun ref`, `consume` and `^`? I
suppose Pony is different, so I should learn some more about this language
first!

Pony has the somewhat novel notion of
[reference capabilities](https://tutorial.ponylang.org/capabilities/reference-capabilities.html).
That means, a reference to an object isn't just a reference, but it also
records what the reference's receiver can do with it. Think of it as `const`
references in C++, but on steroids. Besides being immutable (`val`), references
can also be read-only (`box`), mutable (`ref`), isolated (`iso`) meaning this
is the only reference in existence to the object, transition (`trn`) meaning
this is the only writable reference in existence to the object, and tag (`tag`)
meaning you can do nothing except storing and comparing references.

So this clears up some of the mysterious syntax:

* `fun ref` means the function can only be called on mutable references. In
  C++ parlance, this would be a non-const function.
* `fun tag` means the actor itself isn't even accessed; it's a bit similar to a
  static method in other languages, although it does have a `this` pointer.
* `consume` is like `std::move` in C++, except with the compile-time guarantee
  that you can't accidentally access it again later.
* `^` is a suffix that indicates an ephemeral type, which is a type for an
  anonymous value.
* `be` indicates a behaviour, which is an asynchronous function. Think of it
  like `async function` in ES6, except you can't return a `Promise` that the
  caller can wait on. So maybe it's more like message passing with an implicit
  message loop per object.

Synchronization is done on a per-actor basis. It's as if in Java you made all
methods `synchronized`, except of course Java would run them synchronously,
rather than in the background. I'm not sure I like this notion of having actors
be both the "unit of sequentiality" (monitor in Java) and the "unit of data"
(object in Java), but that's how it works. Then again, you don't need to use
actors as "unit of data"; Pony has regular classes too.

`env.stdin` is an actor, so it runs in its own "green thread". To read from it,
we call it as a function, passing it an object that implements the
`StdinNotify` interface, which receives the data in chunks of unspecified size
through its `apply` method (which seems to be the overloaded function call
operator). At EOF, `dispose` is called.

To process this chunked data, the
[`buffered.Reader`](https://stdlib.ponylang.org/buffered-Reader/) class is
helpful. Error handling is of course mandatory; the `try ... end` construct
looks similar to `try`/`catch`, but error handling is actually more like
`Maybe` monads or nullable types, and consequently indicated by a `?` suffix on
the type name and also on any method calls that might call `error`.

For the actual algorithm, my initial thought was to have two `Generator` actor
and a `Judge` actor, and have them communicate using behaviours. One problem is
that behaviours are fire-and-forget; to get values back from a generator, you
either need to pass it a callback (which makes zip'ing the two iterators
difficult) or pass it a promise (which is syntactically awkward). Besides, even
if Pony is as fast as it claims to be, all this message passing is going to be
a lot more costly than the 3-second loop we saw using PyPy. So I settled for
iterators instead, which have good support in Pony too.

After I got all my reference capabilities straight, the Pony program gave the
right answer in 3 seconds – _including_ compile time. Actual running time is
only 0.7 seconds. Nice!

---

The second part isn't much more difficult. Just change a few numbers, add a
modulo check, and Bob's your pony.

As said, I tried Pony a few days ago and got really frustrated because of the
difficulty reading stdin. But once you get into the right mindset, Pony's
actually a pretty fun language with a lot of static guarantees, great compiler
messages, reasonable documentation and a very good tutorial. It does really
seem like a solid competitor to Rust, Nim, Go et al. to become the
close-to-the-metal yet safe parallel programming language of the future.
