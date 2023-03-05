import gleam/io
import gleam/string
import gleam/map
import gleam/list
import gleam/option.{None, Option, Some}
import ansi/ansi.{Ansi}

pub type Dahlia {
  Dahlia(string: String, map: Option(map.Map(String, Ansi)))
}

pub fn dahlia(str: String) -> Dahlia {
  Dahlia(str, None)
}

pub fn build(d: Dahlia) -> String {
  let map = case d.map {
    Some(map) -> map
    None ->
      map.new()
      |> map.insert("a", ansi.AnsiColor4(31))
  }

  build_inner(string.to_graphemes(d.string), map)
  |> string.join("")
}

fn build_inner(
  graphemes: List(String),
  codes: map.Map(String, Ansi),
) -> List(String) {
  case graphemes {
    [] -> []
    ["&", code, ..rest] ->
      case map.get(codes, code) {
        Ok(ansi) ->
          list.append(
            ansi.serialize(ansi)
            |> string.to_graphemes(),
            build_inner(rest, codes),
          )
        Error(_) ->
          list.append(["&"], build_inner(list.append([code], rest), codes))
      }
    [head, ..tail] -> list.append([head], build_inner(tail, codes))
  }
}

pub fn with_map(d: Dahlia, map: map.Map(String, Ansi)) {
  Dahlia(..d, map: Some(map))
}

pub fn main() {
  dahlia("&a&bHello from dahlia!")
  |> with_map(
    map.new()
    |> map.insert("a", ansi.AnsiSGR(3))
    |> map.insert("b", ansi.AnsiColor4(31)),
  )
  |> build()
  |> io.println
}
