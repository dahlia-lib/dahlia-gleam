[![Package Version](https://img.shields.io/hexpm/v/dahlia)](https://hex.pm/packages/dahlia)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/dahlia/)

# Dahlia.gleam

A Gleam port of [Dahlia](https://github.com/dahlia-lib/Dahlia) — a simple text formatting package, inspired by the game Minecraft.

## Exmaple

```gleam
dahlia.dahlia()
  |> dahlia.dprint("&aHello Wolrd")
```


## Installation

If available on Hex this package can be added to your Gleam project:

```sh
gleam add dahlia
```

and its documentation can be found at <https://hexdocs.pm/dahlia>.


# Color Codes

You can find a list of color codes on [the minecraft wiki](https://minecraft.fandom.com/wiki/Formatting_codes).

Addtionally you can do `&[#HEXNUM]` for a custom foreground color and `&~[#HEXNUM]` for
a custom background color.





