import gleam/string
import gleeunit
import gleeunit/should
import dahlia
import dahlia/colors

pub fn main() {
  gleeunit.main()
}

fn ansi_escape_code() -> String {
  let assert Ok(ansi_escape_codepoint) = string.utf_codepoint(0x1b)
  string.from_utf_codepoints([ansi_escape_codepoint])
}

pub fn basic_colors_test() {
  dahlia.dahlia()
  |> dahlia.with_colors(colors.three_bit())
  |> dahlia.convert("&aHello World!")
  |> should.equal(ansi_escape_code() <> "[32mHello World!")

  dahlia.dahlia()
  |> dahlia.with_colors(colors.three_bit())
  |> dahlia.convert("&~aHello World!")
  |> should.equal(ansi_escape_code() <> "[42mHello World!")
}

pub fn invalid_code_test() {
  dahlia.dahlia()
  |> dahlia.with_colors(colors.three_bit())
  |> dahlia.convert("&ZHello World!")
  |> should.equal("&ZHello World!")

  dahlia.dahlia()
  |> dahlia.with_colors(colors.three_bit())
  |> dahlia.convert("&~ZHello World!")
  |> should.equal("&~ZHello World!")
}

pub fn custom_escape_test() {
  dahlia.dahlia()
  |> dahlia.with_colors(colors.three_bit())
  |> dahlia.with_escape_character("%")
  |> dahlia.convert("%aHello World!")
  |> should.equal(ansi_escape_code() <> "[32mHello World!")
}

pub fn escape_and_test() {
  dahlia.dahlia()
  |> dahlia.with_colors(colors.three_bit())
  |> dahlia.convert("\\&aHello \\&aWorld!")
  |> should.equal("&aHello &aWorld!")

  dahlia.dahlia()
  |> dahlia.with_colors(colors.three_bit())
  |> dahlia.convert("\\&ZHello \\&ZWorld!")
  |> should.equal("&ZHello &ZWorld!")
}

pub fn hex_notation_test() {
  dahlia.dahlia()
  |> dahlia.convert("&[#FFAFF3]Hello World!")
  |> should.equal(ansi_escape_code() <> "[38;2;255;175;243mHello World!")

  dahlia.dahlia()
  |> dahlia.convert("&~[#FFAFF3]Hello World!")
  |> should.equal(ansi_escape_code() <> "[48;2;255;175;243mHello World!")
}
