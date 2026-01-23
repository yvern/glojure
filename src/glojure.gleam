import argv
import gleam/float
import gleam/int
import gleam/io
import gleam/list
import gleam/option.{None, Some}
import gleam/result
import gleam/string
import gleamy/bench

pub fn fold(list, init, trs, red) {
  list.fold(list, init, trs(red))
}

pub fn map_(f: fn(a) -> b) {
  fn(r) { fn(acc, step) { r(acc, f(step)) } }
}

pub fn map(g, f: fn(a) -> b) {
  fn(r) { g(fn(acc, step) { r(acc, f(step)) }) }
}

pub fn flat_map_(f: fn(a) -> List(b)) {
  fn(r) { fn(acc, step) { list.fold(f(step), acc, r) } }
}

pub fn flat_map(g, f: fn(a) -> List(b)) {
  fn(r) { g(fn(acc, step) { list.fold(f(step), acc, r) }) }
}

pub fn filter_(f: fn(x) -> Bool) {
  fn(r) {
    fn(acc, step) {
      case f(step) {
        True -> r(acc, step)
        False -> acc
      }
    }
  }
}

pub fn filter(g, f: fn(x) -> Bool) {
  fn(r) {
    g(fn(acc, step) {
      case f(step) {
        True -> r(acc, step)
        False -> acc
      }
    })
  }
}

pub fn transduced_bla(nums) {
  fold(
    nums,
    0,
    map_(int.to_string)
      |> flat_map(string.to_utf_codepoints)
      |> map(string.utf_codepoint_to_int)
      |> filter(int.is_odd),
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

pub fn better_list_bla(nums) {
  use acc, step <- list.fold(nums, 0)
  let codepoints = string.to_utf_codepoints(int.to_string(step))
  let sum =
    codepoints
    |> list.map(string.utf_codepoint_to_int)
    |> list.filter(int.is_odd)
    |> int.sum

  acc + sum
}

fn inner_rec_bla(nums, codepoints, acc) {
  case nums, codepoints {
    nums, [first, ..rest] -> {
      let char = string.utf_codepoint_to_int(first)
      case int.is_odd(char) {
        True -> inner_rec_bla(nums, rest, acc + char)
        False -> inner_rec_bla(nums, rest, acc)
      }
    }

    [num, ..rest], [] ->
      inner_rec_bla(rest, string.to_utf_codepoints(int.to_string(num)), acc)

    [], [] -> acc
  }
}

pub fn rec_bla(nums) {
  inner_rec_bla(nums, [], 0)
}

fn inner_rec_flat(nums, codepoints, acc) {
  case nums, codepoints {
    nums, [first, ..rest] if first % 2 != 0 ->
      inner_rec_flat(nums, rest, acc + first)

    nums, [_, ..rest] -> inner_rec_flat(nums, rest, acc)

    [num, ..rest], [] ->
      inner_rec_flat(
        rest,
        list.map(
          string.to_utf_codepoints(int.to_string(num)),
          string.utf_codepoint_to_int,
        ),
        acc,
      )

    [], [] -> acc
  }
}

pub fn rec_bla_flat(nums) {
  inner_rec_flat(nums, [], 0)
}

fn inner_rec_flatter(nums, codepoints, next, acc) {
  case nums, codepoints, next {
    [num, ..rest], [first], Some(nxt) if nxt % 2 != 0 ->
      inner_rec_flatter(
        rest,
        string.to_utf_codepoints(int.to_string(num)),
        Some(string.utf_codepoint_to_int(first)),
        acc + nxt,
      )

    nms, cdpts, Some(nxt) if nxt % 2 != 0 ->
      inner_rec_flatter(nms, cdpts, None, acc + nxt)

    nms, cdpts, Some(_) -> inner_rec_flatter(nms, cdpts, None, acc)

    nms, [first, ..rest], None ->
      inner_rec_flatter(
        nms,
        rest,
        Some(string.utf_codepoint_to_int(first)),
        acc,
      )

    [num, ..rest], [], None ->
      inner_rec_flatter(
        rest,
        string.to_utf_codepoints(int.to_string(num)),
        None,
        acc,
      )

    [], [], _ -> acc
  }
}

pub fn rec_bla_flatter(nums) {
  inner_rec_flatter(nums, [], None, 0)
}

pub fn main() -> Nil {
  let assert Ok(Ok(max)) =
    argv.load().arguments |> list.first |> result.map(int.parse)

  let assert Ok(powers10) = {
    use exp <- list.try_map(list.range(1, max))
    exp |> int.to_float |> int.power(10, _)
  }

  bench.run(
    {
      use max <- list.map(powers10)
      let upper_bound = float.round(max)
      bench.Input(int.to_string(upper_bound), list.range(1, upper_bound))
    },
    [
      bench.Function("list based", listed_bla),
      bench.Function("trs based", transduced_bla),
      bench.Function("better list", better_list_bla),
      bench.Function("recur", rec_bla),
      bench.Function("recur flat", rec_bla_flat),
      bench.Function("recur flatter", rec_bla_flatter),
    ],
    [bench.Duration(10_000), bench.Warmup(100)],
  )
  |> bench.table([bench.IPS, bench.Mean, bench.SD, bench.P(99)])
  |> io.println()
}
