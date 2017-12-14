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

Part Two
