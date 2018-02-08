Day16 solution in [Processing](https://processing.org/) language.


### Why?


Processing is a language used for visualization, essentially a dumbed down Java "for artists and non-programmers".

An attempt at doing a simple visualization failed, turns out Processing 3+ does not work anymore with JavaScript directly; I tried running the code via [Processing.js](http://processingjs.org/) and that did not work, failing when working with arrays/strings. One still could do it in the Processing own IDE (and export as an executable application), but that's not as appealing as the web browser, so I just moved on.

So while there is a bunch of [amazing examples](https://www.openprocessing.org/) of generative art in Processing out there, as a programming language it's not really appealing.

### Running

[Download Processing](https://processing.org/download/) and make sure that `processing-java` is on your `PATH`.

Then:

```bash
$ make
```