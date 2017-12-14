# [Day 14](http://adventofcode.com/2017/day/14) in CUDA

Okay, I'll admit, calling NVIDIA's GPGPU programming technology CUDA a
"language" is a bit of a stretch. Actually it's just C++ with some extensions.
But because it does enforce a different programming model upon you, I'm going
to count it anyway. Besides, I allowed OpenCL last year, which is mostly just
C.

Since a GPU program can't run on its own, I also need some C++ glue code, but
the bulk of the algorithm will be running on the GPU. This means no use of the
C++ or C standard libaries – in particular, no `std::string` or `sprintf`.

On to the puzzle. My knot hash implementation is stuck somewhere in an Erlang
message box, so I'll have to reimplement it. Then it's a simple matter of
running it over the 256 rows and collecting the output. In glorious parallel
code, of course.

As soon as it compiled, it actually worked and gave the right answer. This made
me happy, because debugging GPU code can be unfun. NVIDIA has some supposedly
great tooling, but it would have taken some time to set it up and figure it all
out (if it works on Linux at all).

---

Now on to part two: a connected components analysis. How could this efficiently
be done in parallel on a GPU? It's not embarrassingly parallel, because one
square somewhere can affect connectedness of components that span the entire
grid. So we could do some bottom-up approach, starting with 1×1 squares,
linking them into 2×2, then 4×4, and so on. The drawback is that this is tricky
to get right. We could also work along scanlines: first do a horizontal pass,
then a vertical one, and repeat until everything is linked up. This is
sensitive to pathological cases where we'd need O(_n_) iterations (where _n_ is
the number of pixels) before convergence happens.

It turns out that CCL (connected components labeling) on the GPU is a
nontrivial problem, and several
[papers](http://hpcg.purdue.edu/bbenes/papers/Stava2011CCL.pdf)
[have](http://citeseerx.ist.psu.edu/showciting?cid=477854)
[been](https://www.researchgate.net/publication/224257745_Computing_Strongly_Connected_Components_in_Parallel_on_CUDA)
[written](http://cstar.iiit.ac.in/~kkishore/conn_c.pdf) about it.

I'm not inclined to put a lot of effort into this right now, so I'll just do
the entire thing in a single CUDA kernel invocation. And because I'm lazy, I'll
just do the whole thing using flood fills. The advantage over established
algorithms is that there's no need to relabel all components afterwards; I can
just assign incremental labels and the total count pops right out at the end.
Lame but effective.

However, I ran into a problem:

    ptxas warning : Stack size for entry function '_Z24labelConnectedComponentsPiS_' cannot be statically determined
    Bus error (core dumped)

I think this is due to recursion, and might be CUDA-speak for "stack overflow".
But even giving it 10 MB of stack (using
`cudaDeviceSetLimit(cudaLimitStackSize, 10 * (1 << 20));`) did not solve it.
Alright, alright, I'll use a queue instead of recursion. A nice ring buffer,
to salvage at least _some_ of my dignity.
