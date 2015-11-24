## Elixir version of Encurses 0.4.1
## by Massn <massn23579@gmail.com>
##
## ============================================================================
## Encurses 0.4.1
##
## Copyright © 2012 Jeff Zellner <jeff.zellner@gmail.com>. All Rights Reserved.
##
## Redistribution and use in source and binary forms, with or without
## modification, are permitted provided that the following conditions are met:
##
##   1. Redistributions of source code must retain the above copyright notice,
##      this list of conditions and the following disclaimer.
##   2. Redistributions in binary form must reproduce the above copyright
##      notice, this list of conditions and the following disclaimer in the
##      documentation and/or other materials provided with the distribution.
##   3. The name of the author may not be used to endorse or promote products
##      derived from this software without specific prior written permission.
##
## THIS SOFTWARE IS PROVIDED BY AUTHOR "AS IS" AND ANY EXPRESS OR IMPLIED
## WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
## MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
## EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
## SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
## PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
## OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
## WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
## OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
## ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
## ============================================================================

defmodule Exncurses do
  @on_load :load_nif

  ## =============================================================================
  ## NIF Loading
  ## =============================================================================

  def load_nif do
    path = Path.dirname(Mix.Project.deps_path) <> "/priv/exncurses"
    :ok = :erlang.load_nif(path, 0)
    #{:error, path}
  end

  ## =============================================================================
  ## Application API
  ## =============================================================================

  ## refresh

  def refresh, do: e_refresh

  def refresh(win) when is_integer(win), do: e_wrefresh(win)

  ## window management

  def newwin(width, height, start_x, start_y) when
  is_integer(width) and
  is_integer(height) and is_integer(start_x) and
  is_integer(start_y) do
    e_newwin(width, height, start_x, start_y)
  end

  def delwin(win) when is_integer(win) do
    e_delwin(win)
  end

  def endwin, do: e_endwin

  ## initscr

  def initscr, do: e_initscr

  ## cbreak

  def cbreak, do: e_cbreak

  def nocbreak, do: e_nocbreak

  ## echo

  def echo, do: e_echo

  def noecho(), do: e_noecho()

  ## erase

  def erase, do: e_erase

  def erase(win) when is_integer(win), do: e_werase(win)

  ## addch

  def addch(char) when is_integer(char), do: e_addch(char)

  def waddch(win, char) when is_integer(win) and is_integer(char), do: e_waddch(win, char)

  def mvaddch(x, y, char) when is_integer(x) and is_integer(y) and is_integer(char) do
    e_mvaddch(x, y, char)
  end

  def mvwaddch(win, x, y, char) when is_integer(win) and is_integer(x) and
  is_integer(y) and is_integer(char) do
    e_mvwaddch(win, x, y, char)
  end

  ## addstr

  def addstr string  when is_list(string) do
    str = :lists.flatten string
    e_add(:erlang.iolist_size str, str)
  end

  def waddstr(win, string) when is_integer(win) and is_list(string) do
    str = :lists.flatten(string)
    e_waddstr(win, :erlang.iolist_size(str), str)
  end

  def mvaddstr(x, y, string) when is_integer(x) and is_integer(y) and
  is_list(string) do
    str = :lists.flatten(string)
    e_mvaddstr(x, y, :erlang.iolist_size(str), str)
  end

  def mvwaddstr(win, x, y, string) when is_integer(win) and is_integer(x) and
  is_integer(y) and is_list(string) do
    str = :lists.flatten(string)
    e_mvwaddstr(win, x, y, :erlang.iolist_size(str), str)
  end

  ## move

  def move(x, y) when is_integer(x) and is_integer(y), do: e_move(x, y)

  def move(win, x, y) when is_integer(win) and is_integer(x) and
  is_integer(y) do
    e_wmove(win, x, y)
  end

  ## get x and y

def getxy, do: e_getxy()

def getxy win when is_integer win do
    e_wgetxy win
end

def getmaxxy, do: e_getmaxxy

def getmaxxy win when is_integer win do
    e_wgetmaxxy win
end

 ## curs_set

def curs_set flag when is_integer flag do
    e_curs_set flag
end

 ## has_colors

def has_colors, do: e_has_colors

 ##  start_color

start_color() ->
    e_start_color().

%% init_pair

init_pair(N, FColor, BColor) when is_integer(N) andalso is_integer(FColor)
        andalso is_integer(BColor) ->
    e_init_pair(N, FColor, BColor).

%% attron/attroff

attron(Mask) when is_integer(Mask) ->
    e_attron(Mask).

attron(Win, Mask) when is_integer(Win) andalso is_integer(Mask) ->
    e_wattron(Win, Mask).

attroff(Mask) when is_integer(Mask) ->
    e_attroff(Mask).

attroff(Win, Mask) when is_integer(Win) andalso is_integer(Mask) ->
    e_wattroff(Win, Mask).

%% nl/nonl

nl() ->
    e_nl().

nonl() ->
    e_nonl().

%% scrollok

scrollok(Win, Flag) when is_integer(Win) andalso is_boolean(Flag) ->
    case Flag of
        true -> e_scrollok(Win, 1);
        false -> e_scrollok(Win, 0)
    end.

%% hline/vline

hline(Char, MaxN) when is_integer(Char) andalso is_integer(MaxN) ->
    e_hline(Char, MaxN).

hline(Win, Char, MaxN) when is_integer(Win) andalso is_integer(Char)
        andalso is_integer(MaxN) ->
    e_whline(Win, Char, MaxN).

vline(Char, MaxN) when is_integer(Char) andalso is_integer(MaxN) ->
    e_vline(Char, MaxN).

vline(Win, Char, MaxN) when is_integer(Win) andalso is_integer(Char)
        andalso is_integer(MaxN) ->
    e_wvline(Win, Char, MaxN).

%% border

border(Ls, Rs, Ts, Bs, TLs, TRs, BLs, BRs)
  when is_integer(Ls) andalso is_integer(Rs) andalso
        is_integer(Ts) andalso is_integer(Bs) andalso is_integer(TLs) andalso
        is_integer(TRs) andalso is_integer(BLs) andalso is_integer(BRs) ->
    e_border(Ls, Rs, Ts, Bs, TLs, TRs, BLs, BRs).

border(Win, Ls, Rs, Ts, Bs, TLs, TRs, BLs, BRs)
  when is_integer(Win) andalso is_integer(Ls) andalso
        is_integer(Rs) andalso is_integer(Ts) andalso is_integer(Bs) andalso
        is_integer(TLs) andalso is_integer(TRs) andalso is_integer(BLs) andalso
        is_integer(BRs) ->
    e_wborder(Win, Ls, Rs, Ts, Bs, TLs, TRs, BLs, BRs).

%% box

box(Win, Horz, Vert) when is_integer(Win) andalso is_integer(Horz) andalso
        is_integer(Vert) ->
    e_box(Win, Horz, Vert).

%% keypad

keypad(Flag) when is_boolean(Flag) ->
    keypad(0, Flag).

keypad(Win, Flag) when is_integer(Win) and is_boolean(Flag) ->
    case Flag of
        true -> e_keypad(Win, 1);
        false -> e_keypad(Win, 0)
    end.

%% getch

getch() ->
    getch(0).

getch(Win) ->
    e_wgetch(self(), Win),
    receive
        Char -> Char
    end.






















  ## =============================================================================
  ## Internal functions
  ## =============================================================================

  defp e_refresh(), do: :not_initialized

  defp e_wrefresh(_win), do: :not_initialized

  defp e_newwin(_width, _height, _start_x, _start_y), do: :not_initialized

  defp e_delwin(_win), do: :not_initialized

  defp e_endwin, do: :not_initialized

  defp e_initscr, do: :not_initialized

  defp e_cbreak, do: :not_initialized

  defp e_nocbreak, do: :not_initialized

  defp e_echo, do: :not_initialized

  defp e_noecho, do: :not_initialized

  defp e_erase, do: :not_initialized

  defp e_werase(_win), do: :not_initialized

  defp e_addch(_char), do: :not_initialized

  defp e_waddch(_win, _char), do: :not_initialized

  defp e_mvaddch(_x, _y, _char), do: :not_initialized

  defp e_mvwaddch(_win, _x, _y, _char), do: :not_initialized

end

