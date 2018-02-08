Day22 solution in [Tcl](https://en.wikipedia.org/wiki/Tcl) language.


### Why?

To live through the suffering.

Tcl is a well-respected, time-proven language, which nevertheless I found to be not much fun to write code in.

Having almost not used it before, it felt alien in many regards, and it's not because it introduces a new paradigm or anything.

Instead, it's just your usual run-of-the-mill imperative scripting language, which nevertheless tries to be different apparently just for the sake of it. For example:

* hash maps are called "arrays" and arrays are called "lists". Go figure
* in order to evaluate an expression you need to explicitly say "gee, it's an expression" (e.g. `expr {1 + 2}`). It almost looks like it's trying to be a LISP without using prefix notation.
* there is no assignment operator, one has to do things like `set x value`
* incidental troubles, like passing "arrays" into nested procedures

and so on. 

Also, it appears to be slow - my implementation is about 5x slower than the reference Python implementation. It's not quite apples-to-apples, though.


### Installation

You may already have it installed. If not, then on e.g. Ubuntu:


```bash
$ sudo apt-get install tclsh
```

### Running

```bash
$ make
```

Note that it may take about a minute to run.