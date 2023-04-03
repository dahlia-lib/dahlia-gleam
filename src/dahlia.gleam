import gleam/io
import gleam/string
import gleam/map
import gleam/list
import gleam/option.{None, Option, Some}
import dahlia/ansi.{Ansi}
import dahlia/colors
import dahlia/env

pub type Dahlia {
  Dahlia(colors: Option(map.Map(String, Ansi)), escape_character: String)
}

/// Get a new dahlia object.
pub fn dahlia() -> Dahlia {
  Dahlia(colors: None, escape_character: "&")
}

/// Convert a string to a formatted string.
///
/// ```gleam
/// let result = dahlia.dahlia()
///   |> dahlia.convert("&aABCD")
/// io.println(result)
/// ```
pub fn convert(d: Dahlia, string str: String) -> String {
  let map = case env.get_env("NO_COLOR") {
    Ok("1") -> map.new()
    _ ->
      case d.colors {
        Some(map) -> map
        None ->
          case env.get_env("TERM") {
            Ok(env) ->
              case env {
                "xterm" -> colors.eight_bit()
                "xterm-256color" -> colors.twentyfour_bit()
                // Idk what is support so its set to 3 to be safe.
                _ -> colors.three_bit()
              }
            Error(_) -> colors.twentyfour_bit()
          }
      }
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
    ["\\", esc, ..rest] if esc == escape_character ->
      list.append([esc], convert_inner(rest, escape_character, codes))
    [esc, "[", "#", a, b, c, d, e, f, "]", ..rest] if esc == escape_character -> {
      let assert Ok(ansi) = ansi.from_hex("#" <> a <> b <> c <> d <> e <> f)
      serialize_and_build_rest(ansi, False, rest, escape_character, codes)
    }
    [esc, "~", "[", "#", a, b, c, d, e, f, "]", ..rest] if esc == escape_character -> {
      let assert Ok(ansi) = ansi.from_hex("#" <> a <> b <> c <> d <> e <> f)
      serialize_and_build_rest(ansi, True, rest, escape_character, codes)
    }
    [esc, "~", code, ..rest] if esc == escape_character ->
      case map.get(codes, code) {
        Ok(ansi) ->
          serialize_and_build_rest(ansi, True, rest, escape_character, codes)
        Error(_) ->
          list.append(
            [escape_character],
            convert_inner(
              list.append(["~", code], rest),
              escape_character,
              codes,
            ),
          )
      }
    [esc, code, ..rest] if esc == escape_character ->
      case map.get(codes, code) {
        Ok(ansi) ->
          serialize_and_build_rest(ansi, False, rest, escape_character, codes)
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
  background: Bool,
  rest: List(String),
  escape_character: String,
  codes: map.Map(String, Ansi),
) {
  list.append(
    ansi.serialize(ansi, background)
    |> string.to_graphemes,
    convert_inner(rest, escape_character, codes),
  )
}

/// Print a string as a formatted string and return the Dahlia object.
///
/// ```gleam
/// dahlia.dahlia()
///   |> dahlia.dprint("&aHello Wolrd")
///   |> dahlia.dprint("&aSomething else")
/// ```
pub fn print(d: Dahlia, string str: String) -> Dahlia {
  convert(d, str)
  |> io.print
  d
}

/// Print a string as a formatted string, but with a newline
/// after it. Also return the Dahlia object.
pub fn println(d: Dahlia, string str: String) -> Dahlia {
  convert(d, str)
  |> io.println
  d
}

/// Use a custom color set for the dahlia object.
///
/// ```gleam
/// import dahlia
/// import dahlia/colors
///
/// fn main() {
///   dahlia.dahlia()
///   |> dahlia.with_colors(colors.three_bit())
///   |> dahlia.dprint("&aHello Wolrd")
/// }
/// ```
pub fn with_colors(d: Dahlia, colors: map.Map(String, Ansi)) {
  Dahlia(..d, colors: Some(colors))
}

/// Merge colors to the current color set for the dahlia object.
///
/// ```gleam
/// import dahlia
/// import dahlia/ansi
/// import gleam/map
///
/// fn main() {
///   dahlia.dahlia()
///   |> dahlia.merge_colors(
///     map.new()
///     |> map.insert("c", ansi.Ansi24(255, 175, 243))
///   )
///   |> dahlia.dprint("&cHello Wolrd")
/// }
/// ```
pub fn merge_colors(d: Dahlia, colors: map.Map(String, Ansi)) {
  case d.colors {
    Some(old_colors) -> Dahlia(..d, colors: Some(map.merge(old_colors, colors)))
    None -> Dahlia(..d, colors: Some(colors))
  }
}

/// Print the reset colors character and return the dahlia object.
pub fn reset(d: Dahlia) -> Dahlia {
  dahlia()
  |> print("&r")
  d
}

/// Use a custom escape character for you dahlia strings.
///
/// ```gleam
/// import dahlia
/// import dahlia/colors
///
/// fn main() {
///   dahlia.dahlia()
///   |> dahlia.with_escape_character("%")
///   |> dahlia.dprint("%aHello Wolrd")
/// }
/// ```
pub fn with_escape_character(d: Dahlia, escape_character: String) -> Dahlia {
  Dahlia(..d, escape_character: escape_character)
}
