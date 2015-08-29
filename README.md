elixir_sips_rss
===============

A fork of [elixir-sips-rss](https://github.com/brkattk/elixir-sips-rss) written in [Elixir](http://elixir-lang.org/).

Just an exmaple of what it would look like in [Elixir](http://elixir-lang.org/). You Probably shouldn't use this.

## Build

Make sure you have [Elixir](http://elixir-lang.org/) installed, clone the repo and run `mix do deps.get, deps.compile`. Then run `mix escript.build` to build elixir_sips_rss.

## Run it

elixir_sips_rss downloads episodes into an `episodes` directory. Run `./elixir_sips_rss` to print usage information. Basic usage is `elixir_sips_rss --username USERNAME --password PASSWORD` where USERNAME and PASSWORD are your elixir sips login info.
