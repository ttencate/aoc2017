# [Day 7](http://adventofcode.com/2017/day/7) in CoffeeScript

I don't have a lot of time today, so I decided to solve today's puzzle in a
language I actually knew once: CoffeeScript.

The first question is simple: which name occurs on the left, but not on the
right? But I'm going to be building the complete graph structure, because I
have a feeling I might need it in the second part.

One reason I chose a JavaScript derivative is because input parsing is
nontrivial here, and JavaScript has surprisingly decent regexp support. So that
was easy.

---

It turns out I was right about the second half; now we need to actually
traverse the graph. We can do this from the root down (or up, if you follow the
puzzle text or have ever seen a real tree). First we do a pass to compute and
store all the total weights.

One fact that isn't shown in the example is this: an imbalance propagates
downwards through the tree. After all, if node N has the wrong weight, this
means the _entire_ tower would be in balance if we changed N's weight. That
means that the parent of node N will also see an imbalance. So one would think
that we can do a top-down pass: start at the root, and follow imbalances until
we can't find one anymore. However, the problem is: if there are only two
nodes, which one do we follow? Answer: the one that is itself imbalanced.
That's a fair amount of code to get right, and I had a feeling there should be
a simpler way.

This thinking led me to an observation: the level of the tree at which the
imbalance manifests, is always one level _above_ the place we are interested
in. So we can take a non-recursive approach: test each node locally, checking
whether it's balanced _and_ its total weight matches that of its siblings. If
it has fewer than two siblings, we don't bother: if we spot an imbalance
between just two siblings, we cannot tell which is to blame, so the input would
be ambiguous.

This should all work fine, but I tried this and several other approaches and
they all gave the wrong answer (multiple answers, in fact). Eventually I
tracked it down to my `sumWeights` map containing the wrong values. This turned
out to be caused by a CoffeeScript quirk (I'm beginning to remember why I don't
like this language): a recursive function was doing `for child in children`,
but a variable `child` also existed in an outer scope. In plain JavaScript, I'd
have declared `var child` (or `let child`) inside the function, but in
CoffeeScript it silently picked up the global variable. Then the recursive
calls stomped all over it. After working around this by renaming one of the
variables (this really is the only way...) I finally got the right answer.

Spooky action at a distance. Bah.
