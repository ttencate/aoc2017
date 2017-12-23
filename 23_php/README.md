# [Day 23](http://adventofcode.com/2017/day/23) in PHP

Finally, we've reached the point where I can use languages I actually know! Or,
in PHP's case, knew. Around version 3 or so is where I left it. But I'm sure
one can still write horrible code in it, which is exactly what I need.

Apparently PHP has advanced since then, so I'm going to try storing the
instructions not as strings, nor as classes, but as functions bound to their
arguments.

This turns out to be harder than needed. Functions and anonymous functions
("closures") are not the same thing. To bind a regular function to some
arguments, you have to wrap it into an anonymous function and tediously repeat
all arguments. To get around this, I declared all functions I wanted to bind as
anonymous straight away. This also involved changing all call sites, because
you have to write `$my_func()` instead of `my_func()`. Also, closures don't
close over their outer scope automatically; you have to declare `use ($foo)` if
you want to use `$foo` from an outer scope. If you also want to modify it, you
have to write `use (&$foo)`, otherwise assignments to `$foo` from within the
function stay within the function, and you get hilarious bugs like the program
counter not incrementing (true story). This is similar to C++ lambdas, except
worse because you can't say "just use everything by default". Finally, there is
no `bind()` function, just more anonymous functions! So I wrote that one
myself.

---

The puzzle description for the second part strongly suggests that brute force
is hopeless. I set it to run anyway, while I figure out what this assembly code
actually does. It's a relief not to have to work with this PHP language for a
bit.

First, let's simplify assignments and arithmetic, and turn `jnz` instructions
into `if`s and `do` loops:

    set b 65       |  b = 65
    set c b        |  c = b
    jnz a 2        |  if (a != 0) {
    jnz 1 5        |
    mul b 100      |    b = b * 100 + 100000
    sub b -100000  |
    set c b        |    c = b + 17000
    sub c -17000   |
                   |  }
                   |  do {
    set f 1        |    f = 1;
    set d 2        |    d = 2;
                   |    do {
    set e 2        |      e = 2;
                   |      do {
    set g d        |        g = d * e - b;
    mul g e        |
    sub g b        |
    jnz g 2        |        if (g == 0) {
    set f 0        |          f = 0;
                   |        }
    sub e -1       |        e++;
    set g e        |        g = e - b;
    sub g b        |
    jnz g -8       |      } while (g != 0);
    sub d -1       |      d--;
    set g d        |      g = d - b;
    sub g b        |
    jnz g -13      |    } while (g != 0);
    jnz f 2        |    if (f == 0) {
    sub h -1       |      h++;
                   |    }
    set g b        |    g = b - c;
    sub g c        |
    jnz g 2        |    if (g == 0) {
    jnz 1 3        |      break;
                   |    }
    sub b -17      |    b += 17;
    jnz 1 -23      |  } while (true);
                   |  print(h);

Then simplify the arithmetic some more by inlining all the expressions
involving the temporary variable `g`, and turn `do` loops into C-style `for`
loops (under the assumption that each loop will run at least once):

    b = 65                  |
    c = b                   |
    if (a != 0) {           |
      b = b * 100 + 100000  |
      c = b + 17000         |
    }                       |
    do {                    |  for (b = 106500; b <= 123500; b += 17) {
      f = 1;                |    f = true;
      d = 2;                |
      do {                  |    for (d = 2; d < b; d++) {
        e = 2;              |
        do {                |      for (e = 2; e < b; e++) {
          g = d * e - b;    |
          if (g == 0) {     |        if (d * e == b) {
            f = 0;          |          f = false;
          }                 |        }
          e++;              |
          g = e - b;        |
        } while (g != 0);   |      }
        d++;                |
        g = d - b;          |
      } while (g != 0);     |    }
      if (f == 0) {         |    if (!f) {
        h++;                |      h++;
      }                     |    }
      g = b - c;            |
      if (g == 0) {         |
        break;              |
      }                     |
      b += 17;              |
    } while (true);         |  }
    print(h);               |  print(h);

So we're left with a pretty short and simple program:

    for (b = 106500; b <= 123500; b += 17) {
      f = true;
      for (d = 2; d < b; d++) {
        for (e = 2; e < b; e++) {
          if (d * e == b) {
            f = false;
          }
        }
      }
      if (!f) {
        h++;
      }
    }
    print(h);

So what does this do? For each value `b` in the range 106500 to 123500 with a
step size of 17, it checks by brute force whether any pair of numbers `d` and
`e` exist whose product form `b`. If this is the case, `h` is incremented. So
it's a super inefficient way to count the number of non-prime numbers in the
given range!

With the debug flag `a` set to 0, the range was simply reduced to the single
number 65, and indeed `h` contains 1 after running the code in this way (65 is
not prime). As an additional confirmation, the number of multiplications was
3969, which is 63×63 (there are 63 numbers in the range of 2 up to and
excluding 65).

So now we just do the same in PHP directly, except more efficiently: instead of
the double loop over `d` and `e`, we use only one loop, which ends at `sqrt(b)`
instead of `b`. Moreover, it breaks as soon as a divisor is found. With just
1000 numbers to test for primality, there is no need to optimize further. And
after fixing the unavoidable off-by-one error, it produces the right answer.
