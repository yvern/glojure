# glojure

[![Package Version](https://img.shields.io/hexpm/v/glojure)](https://hex.pm/packages/glojure)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/glojure/)

Clojure-like transducers for Gleam

```sh
gleam add glojure@1
```

The iteration functions on `list` module rely on intermediate list creation.
Powerfull and optimised as they might be,
sometimes the list being iterated is too big or there are too many steps.
In those cases, the intermediate lists create aditional overhead.
One can build such a pipeline on raw recursion (and willpower),
but that generaly looks very different from the familiar
list pipeline approach.
This is an experiment of applying Clojure's idea of transducers,
delegating all the work to the reducing function,
with minimal intermediate steps.

As a silly benchmark example we:

* get a large list of numbers
* turn them to strings
* split those into characters (and flatten so our lists are longer)
* filter for only odd elements
* add them all

For the erlang target, we got up to 2x improvement for large inputs
(at 10^7 the list pipeline doesn't run anymore, but the transducer one does).
For js (node 25), at 10^5 input elements we got nearly a 10x improvement (kept getting out of heap for larger inputs).

Theres lots to explore here, but I got stuck on handling "stateful" transducers (`drop_*`, `take_*`, windowing/chunking/indexing)

Further documentation can be found at <https://hexdocs.pm/glojure>.

## Development

```sh
gleam test  # Run the tests
make bench  # Run the benchmark suite
```
