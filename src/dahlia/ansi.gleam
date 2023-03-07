//// This module contains tools to work with ansi.

import gleam/string
import gleam/list
import gleam/int
import gleam/result

pub type Ansi {
  /// AnsiColor3 uses a single digit code.
  AnsiColor3(Int)
  /// AnsiColor4 uses a single digit code.
  AnsiColor4(Int)
  /// AnsiColor8 uses a single digit code for a number.
  AnsiColor8(Int)
  /// AnsiColor24 is represented as RGB
  AnsiColor24(Int, Int, Int)
  /// SGR sequence, such as italics or bold.
  AnsiSGR(Int)
}

/// Create an `AnsiColor24` from a hex value.
/// ```gleam
/// let ansi = ansi.from_hex("#FFAFF3")
/// ```
pub fn from_hex(string str: String) -> Result(Ansi, Nil) {
  use [_, a, b, c, d, e, f] <- result.then(case string.length(str) == 7 {
    False -> Error(Nil)
    True -> Ok(string.to_graphemes(str))
  })

  use r <- result.then(int.base_parse(a <> b, 16))
  use g <- result.then(int.base_parse(c <> d, 16))
  use b <- result.then(int.base_parse(e <> f, 16))

  Ok(AnsiColor24(r, g, b))
}

fn ansi_escape_code() -> String {
  let assert Ok(ansi_escape_codepoint) = string.utf_codepoint(0x1b)
  string.from_utf_codepoints([ansi_escape_codepoint])
}

fn ansi_func(args: List(Int)) -> String {
  let str_args =
    args
    |> list.map(int.to_string)
    |> string.join(";")

  ansi_escape_code() <> "[" <> str_args <> "m"
}

fn if_else(bool: Bool, if_: a, else: a) -> a {
  case bool {
    True -> if_
    False -> else
  }
}

pub fn serialize(ansi: Ansi, background: Bool) -> String {
  case ansi {
    AnsiSGR(n) -> ansi_func([n])
    AnsiColor3(c) -> ansi_func([if_else(!background, c, c + 10)])
    AnsiColor4(c) -> ansi_func([if_else(!background, c, c + 10)])
    AnsiColor8(c) -> ansi_func([if_else(!background, 38, 48), 5, c])
    AnsiColor24(r, g, b) ->
      ansi_func([if_else(!background, 38, 48), 2, r, g, b])
  }
}
