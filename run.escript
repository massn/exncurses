#!/usr/bin/env escript
%%! -noinput -pa ../encurses/ebin +A 10
-include_lib("exncurses/include/exncurses.hrl").
main(_) -> encurses_demo:go().
