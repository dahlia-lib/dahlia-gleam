import gleam/string
import gleam/list
import gleam/int

pub type Ansi {
  /// Ansi4 uses a single digit code.
  AnsiColor3(Int)
  /// Ansi4 uses a single digit code.
  AnsiColor4(Int)
  /// Ansi8 uses a single digit code for a number.
  AnsiColor8(Int, background: Bool)
  /// Ansi 24 is represented as RGB
  AnsiColor24(Int, Int, Int, background: Bool)
  /// SGR sequence, such as italics or bold.
  AnsiSGR(Int)
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

pub fn serialize(ansi: Ansi) -> String {
  case ansi {
    AnsiSGR(n) -> ansi_func([n])
    AnsiColor3(c) -> ansi_func([c])
    AnsiColor4(c) -> ansi_func([c])
    AnsiColor8(c, background) -> ansi_func([if_else(!background, 38, 48), 5, c])
    AnsiColor24(r, g, b, background) ->
      ansi_func([if_else(!background, 38, 48), 2, r, g, b])
  }
}
