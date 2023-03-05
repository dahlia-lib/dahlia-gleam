import gleam/io
import gleam/string
import gleam/map
import gleam/list
import gleam/int
import gleam/option.{None, Option, Some}
import gleam/function
import dahlia/ansi.{Ansi}
import dahlia/colors

pub type Dahlia {
  Dahlia(colors: Option(map.Map(String, Ansi)), escape_character: String)
}

/// Get a new dahlia object.
pub fn dahlia() -> Dahlia {
  Dahlia(colors: None, escape_character: "&")
}

pub fn convert(d: Dahlia, string str: String) -> String {
  let map = case d.colors {
    Some(map) -> map
    None ->
      map.new()
      |> map.insert("a", ansi.AnsiColor4(31))
  }

  convert_inner(string.to_graphemes(str), d.escape_character, map)
  |> string.join("")
}

fn convert_inner(
  graphemes: List(String),
  escape_character: String,
  codes: map.Map(String, Ansi),
) -> List(String) {
  case graphemes {
    [] -> []
    [esc, "[", "#", a, b, c, d, e, f, "]", ..rest] if esc == escape_character -> {
      let assert Ok(r) = int.base_parse(a <> b, 16)
      let assert Ok(g) = int.base_parse(c <> d, 16)
      let assert Ok(b) = int.base_parse(e <> f, 16)

      let ansi = ansi.AnsiColor24(r, g, b, False)
      serialize_and_build_rest(ansi, rest, escape_character, codes)
    }
    [esc, "~", "[", "#", a, b, c, d, e, f, "]", ..rest] if esc == escape_character -> {
      let assert Ok(r) = int.base_parse(a <> b, 16)
      let assert Ok(g) = int.base_parse(c <> d, 16)
      let assert Ok(b) = int.base_parse(e <> f, 16)

      let ansi = ansi.AnsiColor24(r, g, b, True)
      serialize_and_build_rest(ansi, rest, escape_character, codes)
    }
    [esc, code, ..rest] if esc == escape_character ->
      case map.get(codes, code) {
        Ok(ansi) ->
          serialize_and_build_rest(ansi, rest, escape_character, codes)
        Error(_) ->
          list.append(
            [escape_character],
            convert_inner(list.append([code], rest), escape_character, codes),
          )
      }
    [head, ..tail] ->
      list.append([head], convert_inner(tail, escape_character, codes))
  }
}

fn serialize_and_build_rest(
  ansi: Ansi,
  rest: List(String),
  escape_character: String,
  codes: map.Map(String, Ansi),
) {
  list.append(
    ansi.serialize(ansi)
    |> string.to_graphemes,
    convert_inner(rest, escape_character, codes),
  )
}

pub fn dprint(d: Dahlia, string str: String) {
  convert(d, str)
  |> io.print
}

pub fn dprintln(d: Dahlia, string str: String) {
  convert(d, str)
  |> io.println
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

pub fn with_escape_character(d: Dahlia, escape_character: String) -> Dahlia {
  Dahlia(..d, escape_character: escape_character)
}

pub fn main() {
  [
    colors.three_bit(),
    colors.four_bit(),
    colors.eight_bit(),
    colors.twentyfour_bit(),
  ]
  |> list.map(fn(color_map) {
    let dahlia =
      dahlia()
      |> with_colors(color_map)
    "0123456789abcdefg"
    |> string.to_graphemes
    |> list.map(fn(c) { "&" <> c <> c })
    |> string.join("")
    |> function.flip(convert)(dahlia)
    |> io.println
  })
}
