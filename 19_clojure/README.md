# [Day 19](http://adventofcode.com/2017/day/19) in Clojure

I did use Scheme last year, which, like Clojure, is also a LISP derivative, but
the [list of differences](https://clojure.org/reference/lisps) is long and
deep, so I'm allowing Clojure as well now. Besides, I think it'll be fun.

I'm building this up in very small steps, using a large number of small, pure
functions. I hope this will help me get it right on the first try, because
debugging Clojure does not seem like fun. If an exception is thrown, you get a
line number which refers to the _top-level_ expression being evaluated at that
moment (i.e. your "main function"), and a Java stack trace which bears no
relationship whatsoever to your code. Seriously, they couldn't find a way to
annotate the stack trace with the symbols from the Clojure source, rather than
the Clojure interpreter?! (Incidentally, I remember very similar problems with
Groovy. Perhaps the JVM isn't the ultimate answer to everything after all.)

The algorithm is as follows: keep track of the current position and direction.
Upon each step, check if the character ahead is walkable (i.e. not a space –
thank you Eric for providing space-padded input!). If it is, walk there. If
not, check the same for ninety-degree turns left and right, and pick the first
walkable one. Note that we can completely ignore whether a character is a `|`,
`+`, `-` or letter!

Anyhow, after I got all the compilation and runtime errors ironed out, the
program did give the correct output.

---

The second part was a trivial modification.
