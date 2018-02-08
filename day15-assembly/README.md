Day15 solution in [x64 Assembly](https://en.wikipedia.org/wiki/X86-64) language.


### Why?

One rarely needs to write Assembly these days, but reading it can be something that is very useful to be able to do.

The problem is relatively simple, and Assembly is if not right tool for the job here, but at least does not feel completely wrong.

I also made, a [reference C implementation](reference-c-impl/solution.c), and interestingly *it's still twice as fast* as the Assembly version.

The reason is that GCC is being smart and replaces expensive integer division/modulo operation with a smart bunch of multiplications/shifts. I have no idea how it works, but it must be correct. E.g. instead of

```assembly
div	rbx

```
GCC generates something like:

```assembly
mov	rax, r10
mov	rcx, r10
mul	rdi
sub	rcx, rdx
shr	rcx
add	rcx, rdx
shr	rcx, 30
mov	rax, rcx
sal	rax, 31
sub	rax, rcx
mov	rcx, r10
sub	rcx, rax
	
```
See? No divisions. Magic ¯\\_(ツ)_/¯

(Btw, yes, it *is* because of the divisions. I tried replacing `div` with `mul` in the Assembly version and leaving everything else intact - it speeds it up 10x, even though of course generates wrong answer).

So yeah, no reason to do Assembly unless you absolutely know why you are doing it.


### Running
Make sure you have [nasm](http://www.nasm.us/) installed (for Linux distros it may already be).

```bash
$ make
```