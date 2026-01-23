import gleam/int
import gleam/list
import gleeunit
import glojure

pub fn main() -> Nil {
  gleeunit.main()
}

const input = [1, 2, 4, 8, 16]

pub fn map_test() {
  let mapping = glojure.map_(int.multiply(_, 2))

  let actual = glojure.fold(input, 0, mapping, int.add)

  let expected = input |> list.map(int.multiply(_, 2)) |> int.sum

  assert actual == expected
}

pub fn flat_map_test() {
  let flat_mapping = glojure.flat_map_(fn(x) { [x, x] })

  let actual = glojure.fold(input, 0, flat_mapping, int.add)

  let expected = input |> list.map(int.multiply(_, 2)) |> int.sum

  assert actual == expected
}

pub fn filter_keep_all_test() {
  let filtering = glojure.filter_(fn(_) { True })

  let actual = glojure.fold(input, 0, filtering, int.add)

  let expected = input |> int.sum

  assert actual == expected
}

pub fn filter_keep_none_test() {
  let filtering = glojure.filter_(fn(_) { False })

  let actual = glojure.fold(input, 0, filtering, int.add)

  let expected = 0

  assert actual == expected
}

pub fn filter_some_test() {
  let filtering = glojure.filter_(int.is_odd)

  let actual = glojure.fold(input, 0, filtering, int.add)

  let expected = 1

  assert actual == expected
}

pub fn filter_more_test() {
  let filtering = glojure.filter_(int.is_even)

  let actual = glojure.fold(input, 0, filtering, int.add)

  let expected = 30

  assert actual == expected
}

pub fn pre_bench_test() {
  let actual = glojure.transduced_bla(input)

  let expected = glojure.listed_bla(input)

  assert actual == expected
}

pub fn better_list_test() {
  let actual = glojure.better_list_bla(input)

  let expected = glojure.listed_bla(input)

  assert actual == expected
}

pub fn rec_list_test() {
  let actual = glojure.rec_bla(input)

  let expected = glojure.listed_bla(input)

  assert actual == expected
}

pub fn rec_flat_list_test() {
  let actual = glojure.rec_bla_flat(input)

  let expected = glojure.listed_bla(input)

  assert actual == expected
}

pub fn rec_flatter_list_test() {
  let actual = glojure.rec_bla_flatter(input)

  let expected = glojure.listed_bla(input)

  assert actual == expected
}
