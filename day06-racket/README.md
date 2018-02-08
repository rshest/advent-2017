Day06 solution in [Racket](https://en.wikipedia.org/wiki/Racket_(programming_language)).

### Why?

Racket is a modern [Scheme](https://en.wikipedia.org/wiki/Scheme_(programming_language)), which is a protestant [Lisp](https://en.wikipedia.org/wiki/Lisp_(programming_language)).

Once one gets used to S-expressions with all the parentheses, postfix notation etc., then it's actually nice to program in. Btw, note the eight closing parens in one place in the code - it may look horrifying, but it's actually not that bad if one uses DrRacket or Emacs with paredit or whatever else specialized editor.

I intentionally used an imperative-like style, with loops and mutable collections - the goal was to compare it with a Clojure-like experience and see what happens when one wants to be more pragmatic in a language like this.

I found working with collections (vectors and hashmaps in this case) to be too verbose for comfort, though, as opposed to e.g. Clojure again.

### Algorithm

For this problem it was neat to find out that Scheme has a native hash map implementation, and one can use a vector of numbers as a key directly.

A slight twist in the algorithm itself is that I am not distributing the memory blocks one-by-one, but rather try to do it all at once per "memory bank", so we make only one addition per cell in the distribution procedure.

That makes it O(number-of-memory-banks) instead of O(num-memory-blocks), which does not matter much for the particular data we've got in the problem, but could matter a lot for different input numbers.

### Running

Make sure you [installed Racket](https://racket-lang.org/download/) and have it on your `$PATH`, then run:

```bash
$ make
```
