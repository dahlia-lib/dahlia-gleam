import gleam/map
import dahlia/ansi.{
  Ansi, AnsiColor24, AnsiColor3, AnsiColor4, AnsiColor8, AnsiSGR,
}

pub fn formatting() -> map.Map(String, Ansi) {
  map.new()
  |> map.insert("l", AnsiSGR(1))
  |> map.insert("m", AnsiSGR(9))
  |> map.insert("n", AnsiSGR(4))
  |> map.insert("o", AnsiSGR(3))
  |> map.insert("r", AnsiSGR(0))
}

pub fn three_bit() {
  formatting()
  |> map.insert("0", AnsiColor3(30))
  |> map.insert("1", AnsiColor3(34))
  |> map.insert("2", AnsiColor3(32))
  |> map.insert("3", AnsiColor3(36))
  |> map.insert("4", AnsiColor3(31))
  |> map.insert("5", AnsiColor3(35))
  |> map.insert("6", AnsiColor3(33))
  |> map.insert("7", AnsiColor3(37))
  |> map.insert("8", AnsiColor3(30))
  |> map.insert("9", AnsiColor3(34))
  |> map.insert("a", AnsiColor3(32))
  |> map.insert("b", AnsiColor3(34))
  |> map.insert("c", AnsiColor3(31))
  |> map.insert("d", AnsiColor3(35))
  |> map.insert("e", AnsiColor3(33))
  |> map.insert("f", AnsiColor3(37))
  |> map.insert("g", AnsiColor3(33))
}

pub fn four_bit() {
  formatting()
  |> map.insert("0", AnsiColor4(30))
  |> map.insert("1", AnsiColor4(34))
  |> map.insert("2", AnsiColor4(32))
  |> map.insert("3", AnsiColor4(36))
  |> map.insert("4", AnsiColor4(31))
  |> map.insert("5", AnsiColor4(35))
  |> map.insert("6", AnsiColor4(33))
  |> map.insert("7", AnsiColor4(37))
  |> map.insert("8", AnsiColor4(90))
  |> map.insert("9", AnsiColor4(94))
  |> map.insert("a", AnsiColor4(92))
  |> map.insert("b", AnsiColor4(94))
  |> map.insert("c", AnsiColor4(91))
  |> map.insert("d", AnsiColor4(95))
  |> map.insert("e", AnsiColor4(93))
  |> map.insert("f", AnsiColor4(97))
  |> map.insert("g", AnsiColor4(33))
}

pub fn eight_bit() {
  formatting()
  |> map.insert("0", AnsiColor8(0, False))
  |> map.insert("1", AnsiColor8(19, False))
  |> map.insert("2", AnsiColor8(34, False))
  |> map.insert("3", AnsiColor8(37, False))
  |> map.insert("4", AnsiColor8(124, False))
  |> map.insert("5", AnsiColor8(127, False))
  |> map.insert("6", AnsiColor8(214, False))
  |> map.insert("7", AnsiColor8(248, False))
  |> map.insert("8", AnsiColor8(240, False))
  |> map.insert("9", AnsiColor8(147, False))
  |> map.insert("a", AnsiColor8(83, False))
  |> map.insert("b", AnsiColor8(87, False))
  |> map.insert("c", AnsiColor8(203, False))
  |> map.insert("d", AnsiColor8(207, False))
  |> map.insert("e", AnsiColor8(227, False))
  |> map.insert("f", AnsiColor8(15, False))
  |> map.insert("g", AnsiColor8(184, False))
}

pub fn twentyfour_bit() {
  formatting()
  |> map.insert("0", AnsiColor24(0, 0, 0, False))
  |> map.insert("1", AnsiColor24(0, 0, 170, False))
  |> map.insert("2", AnsiColor24(0, 170, 0, False))
  |> map.insert("3", AnsiColor24(0, 170, 170, False))
  |> map.insert("4", AnsiColor24(170, 0, 0, False))
  |> map.insert("5", AnsiColor24(170, 0, 170, False))
  |> map.insert("6", AnsiColor24(255, 170, 0, False))
  |> map.insert("7", AnsiColor24(170, 170, 180, False))
  |> map.insert("8", AnsiColor24(85, 85, 85, False))
  |> map.insert("9", AnsiColor24(85, 85, 255, False))
  |> map.insert("a", AnsiColor24(85, 255, 85, False))
  |> map.insert("b", AnsiColor24(85, 255, 255, False))
  |> map.insert("c", AnsiColor24(255, 85, 85, False))
  |> map.insert("d", AnsiColor24(255, 85, 255, False))
  |> map.insert("e", AnsiColor24(255, 255, 85, False))
  |> map.insert("f", AnsiColor24(255, 255, 255, False))
  |> map.insert("g", AnsiColor24(221, 214, 5, False))
}
