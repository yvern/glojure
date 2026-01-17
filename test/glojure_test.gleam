import gleam/int
import gleam/list
import gleam/string
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

pub fn indexed_test_no() {
  let indexing = glojure.indexed

  let actual = {
    use acc, #(i, _) <- glojure.fold(input, 0, indexing)
    acc + i
  }

  let expected = {
    use acc, _, i <- list.index_fold(input, 0)
    acc + i
  }

  assert actual == expected
}

pub fn transduced_bla(nums) {
  glojure.fold(
    nums,
    0,
    {
      glojure.map_(int.to_string)
      |> glojure.flat_map(string.to_utf_codepoints)
      |> glojure.map(string.utf_codepoint_to_int)
      |> glojure.filter(int.is_odd)
    },
    int.add,
  )
}

pub fn listed_bla(nums) {
  nums
  |> list.map(int.to_string)
  |> list.flat_map(string.to_utf_codepoints)
  |> list.map(string.utf_codepoint_to_int)
  |> list.filter(int.is_odd)
  |> list.fold(0, int.add)
}

pub fn pre_bench_test() {
  let actual = transduced_bla(input)

  let expected = listed_bla(input)

  assert actual == expected
}
