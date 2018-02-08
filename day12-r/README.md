Day12 solution in R.


### Why?

No real justification - even though R is quite widely used in data science, for this particular problem it's only marginally alright, due to things like having to use "environments" as a hash map surrogate and such.

It also was quite slow comparing to the analogous algorithm implemented in Python (which could be because of some hidden operations that change the algorithm complexity behind the scenes, but I did not bother investigating).


### Running
```bash
$ make
```