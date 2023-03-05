import gleam/io
import gleam/string
import gleam/map
import gleam/list
import gleam/int
import gleam/option.{None, Option, Some}
import dahlia/ansi.{Ansi}
import dahlia/colors

pub type Dahlia {
  Dahlia(string: String, colors: Option(map.Map(String, Ansi)))
}

pub fn dahlia(str: String) -> Dahlia {
  Dahlia(str, None)
}

pub fn build(d: Dahlia) -> String {
  let map = case d.colors {
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
    ["&", "[", "#", a, b, c, d, e, f, "]", ..rest] -> {
      let assert Ok(r) = int.base_parse(a <> b, 16)
      let assert Ok(g) = int.base_parse(c <> d, 16)
      let assert Ok(b) = int.base_parse(e <> f, 16)

      let ansi = ansi.AnsiColor24(r, g, b, False)
      serialize_and_build_rest(ansi, rest, codes)
    }
    ["&", "~", "[", "#", a, b, c, d, e, f, "]", ..rest] -> {
      io.println("here")
      let assert Ok(r) = int.base_parse(a <> b, 16)
      let assert Ok(g) = int.base_parse(c <> d, 16)
      let assert Ok(b) = int.base_parse(e <> f, 16)

      let ansi = ansi.AnsiColor24(r, g, b, True)
      serialize_and_build_rest(ansi, rest, codes)
    }
    ["&", code, ..rest] ->
      case map.get(codes, code) {
        Ok(ansi) -> serialize_and_build_rest(ansi, rest, codes)
        Error(_) ->
          list.append(["&"], build_inner(list.append([code], rest), codes))
      }
    [head, ..tail] -> list.append([head], build_inner(tail, codes))
  }
}

fn serialize_and_build_rest(
  ansi: Ansi,
  rest: List(String),
  codes: map.Map(String, Ansi),
) {
  list.append(
    ansi.serialize(ansi)
    |> string.to_graphemes(),
    build_inner(rest, codes),
  )
}

pub fn with_colors(d: Dahlia, colors: map.Map(String, Ansi)) {
  Dahlia(..d, colors: Some(colors))
}

pub fn merge_colors(d: Dahlia, colors: map.Map(String, Ansi)) {
  case d.colors {
    Some(old_colors) -> Dahlia(..d, colors: Some(map.merge(old_colors, colors)))
    None -> Dahlia(..d, colors: Some(colors))
  }
}

pub fn main() {
  [
    colors.three_bit(),
    colors.four_bit(),
    colors.eight_bit(),
    colors.twentyfour_bit(),
  ]
  |> list.map(fn(color_map) {
    "0123456789abcdefg"
    |> string.to_graphemes()
    |> list.map(fn(c) { "&" <> c <> c })
    |> string.join("")
    |> dahlia
    |> with_colors(color_map)
    |> build
    |> io.println
  })
}
