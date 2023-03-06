import gleam/string
import gleeunit
import gleeunit/should
import dahlia
import dahlia/colors
import gleam/io
import dahlia/env

pub fn main() {
  env.get_env("TERM")
  |> io.debug
  // gleeunit.main()
}

fn ansi_escape_code() -> String {
  let assert Ok(ansi_escape_codepoint) = string.utf_codepoint(0x1b)
  string.from_utf_codepoints([ansi_escape_codepoint])
}

// gleeunit test functions end in `_test`
pub fn basic_colors_test() {
  dahlia.dahlia()
  |> dahlia.with_colors(colors.three_bit())
  |> dahlia.convert("&aHello Wolrd!")
  |> should.equal(ansi_escape_code() <> "[32mHello World!")
}
