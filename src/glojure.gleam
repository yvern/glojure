import gleam/list

pub fn comp(g, f) {
  fn(r) { g(f(r)) }
}

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

pub fn indexed(r) {
  fn(acc, step) { r(acc, #(0, step)) }
}
