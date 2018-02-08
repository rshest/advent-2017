Day02 solution in [J programming language](https://en.wikipedia.org/wiki/J_(programming_language) ).


## Why?

"Array-based programming" is a paradigm on its own, so it's worth at least checking out.

## Installation

You need to [install the J base system](http://code.jsoftware.com/wiki/System/Installation) first.

## Running

```bash
$ make
```

## WTF?..

J takes its roots in the APL programming language, it's known to be very terse to the point of being unreadable, especially when using [tacit programming](https://en.wikipedia.org/wiki/Tacit_programming) style.

The way I implemented the solution is not a good style, but I could not help myself :)

### Part 1 walkthrough
```
'solution 1: ', ": +/ >(>./ - <./) each rows

```

Expression `(>./ - <./)` here is a _fork_  of three operators: `(max, subtract, min)`, which translates to `max(x) - min(x)` (that's how "forks" work in J).

This get applied to every row (`each rows`) and then summed together via the sum operator `+/`. The forward slashes (`/`) in all instances mean "apply this operator to every element of whatever the argument is"

Then "printing" is just concatenating strings (also using operator `":` to convert the number to string)

Note that evaluation is basically going right-to-left, where the rightmost thing in this case is our data/argument (`rows`), and to the left of it there is a chain of operators (functions) to apply.

### Part 2 walkthrough
```
'solution 2: ', ": +/ >(>./ @: >./ @: (* (= <.)) @: (%/~)) each rows
```
Once again, note that it's all lumped together out of amusement, not because that's how the code should be written.

The outer part is similar to the Part 1, however the actual computations are more complicated and are a superposition (`@:`) of four operators:
*  `%/~` - having a vector `k`, `k%/k` would create a matrix where each element of `k` is divided (because `%` is a division) by every other element of `k`, e.g.:
```
   k =. 5 9 2 8
   k %/ k
  1 0.555556 2.5 0.625
1.8        1 4.5 1.125
0.4 0.222222   1  0.25
1.6 0.888889   4     1
```
The tilde (`~`) just takes one argument and substitutes it to both places for an operator that expects two.
* `(= <.)` is a _hook_ construct. `<.` is a floor operator which is applied first to `x` and equality operator is applied to this and `x` again. We get a matrix which has `1` where numbers are whole, and `0` where they are not.
* `(* (= <.))` is another hook to zero out non-divisible elements
*  `>./` - find the max element. We do it twice to get the max whole divisor in the matrix at the end.