# [Day 4](http://adventofcode.com/2017/day/4) in awk

I consider myself a bit of a shell wizard, but funnily enough, I've always
sidestepped awk in favour of alternative line-processing utilities like `cut`
and `sed`. Time to fill this gap in my knowledge! For reference, I'm using
[this awk tutorial](http://www.grymoire.com/Unix/Awk.html).

I started with the following base:

    count = 0
    {
      count++
    }
    END { print count }

The bit between curly braces is executed for each line. (Actually, for each
line that matches the pattern in front of the braces, but there's no pattern
here.) The block after `END` is executed at the end. So I expected this to
output the number of lines in the file, but instead, it prints `1`. Why? There
are no local variables in awk, so I would expect the increment to apply to the
global `count` variable. But as it turns out, the initializer `count = 0` is
run for each line as well. So that needs to go in the `BEGIN` block, and all is
good.

The next thing to note is that `$1`, `$2` etc. are not variables, like they are
in bash and Perl. Actually, the `$` is a sort of function that takes one
argument (a number) and spits out the field within the line. `NF` is set to the
number of fields, so this makes it easy to handle a variable number of fields
using a `for` loop.

Then all I need is a hash table to track the words used in the current line. Of
course awk provides: associative arrays are created and addressed using square
brackets, `my_array[key]`.

---

For part two, the trick is to sort the letters of each word before using it as
the associative array index. POSIX awk does not have a sort function, so I'll
just write my own bubble sort. In-line, because POSIX awk does not have
user-defined functions either. It's worth noting here that arrays are 1-based.

In short, I found ack to be a surprisingly practical language to work with, far
more similar to C than I'd expected, and also more powerful than the
alternatives I'd been using so far. A good tool to have in my toolbox!
