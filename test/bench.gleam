import argv
import gleam/float
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleamy/bench
import glojure_test

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
      bench.Input(int.to_string(upper_bound) <> " Ints", list.range(1, upper_bound))
    },
    [
      bench.Function("list based", glojure_test.listed_bla),
      bench.Function("trs based", glojure_test.transduced_bla),
    ],
    [bench.Duration(5000), bench.Warmup(100)],
  )
  |> bench.table([bench.IPS, bench.Mean, bench.SD, bench.P(99)])
  |> io.println()
}
