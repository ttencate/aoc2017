# [Day 12](http://adventofcode.com/2017/day/12) in Dart

After a false start in Elm (which can't really be run in the console) and Pony
(which makes input reading needlessly difficult), I lost patience and decided
to go easy on myself today by using a language that surely, surely should do
what I'm asking from it. Surely?

Installation is simple thanks to an Arch Linux package (not even from AUR).
Running is equally simple. Within minutes, I had a "hello world" program
running. So far, this just looks like another curly-braces-and-semicolons C
derivative, with elements of Java 8 and ES6. But unlike most
compile-to-JavaScript languages, Dart also comes with its own VM and does not
depend on NodeJS, as far as I can tell. Despite Dart being a statically typed
language, the VM does not do static analysis, so if you want "compile-time"
errors you need to run `dartanalyzer` yourself.

The solution for this puzzle is pretty unexciting. I used a regex for parsing
the line (probably overkill), a streamed thingy to break it up, and then a
depth-first search to find the answer.

---

The second part wasn't much harder. Just do DFS traversals from any node that
hasn't been visited before, until none remain.

Brief conclusion about the Dart language, after my 15 minutes of experience
with it: thoroughly unsurprising and unexciting. Dart may have been the bee's
knees before ES6, TypeScript, Flow and all the others happened, but now it's
just one of many. But, for all that, it seems like a fine language, with good
principles and great documentation.
