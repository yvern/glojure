# glojure

Experimeting with Clojure-like transducers in Gleam, the stdlib `list` module, and some recursion shapes.

**please dont read this as a library to be used**

As a silly benchmark example we:

* get a large list of numbers
* turn them to strings
* split those into characters (and flatten so our lists are longer)
* filter for only odd elements
* add them all

Then tried doing the above in different ways:

* list based: simply using `list` functions on a pipeline
* trs based: implementing a basic form of Clojure-inspired transducers
* better list: going through the list once, with a `list.fold`, and have the body process the rest. the hability to use `use` with `list.fold` here does feel really nice
* recur: my first idea of how to do it without iteration helpers. really easy to write and follow, might be the closest to idiomatic Gleam i got (and wouldnt you know it, from this experiment is also the fastest)
* recur flat: basically the above, but trying to "flatten" in the sense of not having nested `case`s. i think this is still a fair try, but is not as nice
* recur flatter: here i basically tried to abuse pattern-matching and open up more branches and have most of the logic there. hard to write and hard to read

## Development

```sh
gleam test  # Run the tests
make bench  # Run the benchmark suite
```
