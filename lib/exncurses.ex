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

  def addstr(string)  when is_list(string) do
    str = :lists.flatten string
    e_addstr(:erlang.iolist_size(str), str)
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

  def getxy(win) when is_integer win do
    e_wgetxy win
  end

  def getmaxxy, do: e_getmaxxy

  def getmaxxy(win) when is_integer win do
    e_wgetmaxxy win
  end

  ## curs_set

  def curs_set(flag) when is_integer flag do
    e_curs_set flag
  end

  ## has_colors

  def has_colors, do: e_has_colors

  ##  start_color

  def start_color, do: e_start_color

  ## init_pair

  def init_pair(n, f_color, b_color) when is_integer(n) and is_integer(f_color)
  and is_integer(b_color) do
    e_init_pair(n, f_color, b_color)
  end

  ## attron/attroff

  def attron(mask) when is_integer(mask), do: e_attron(mask)

  def attron(win, mask) when is_integer(win) and is_integer(mask) do
    e_wattron(win, mask)
  end

  def attroff(mask) when is_integer(mask), do: e_attroff(mask)

  def attroff(win, mask) when is_integer(win) and is_integer(mask) do
    e_wattroff(win, mask)
  end

  ## nl/nonl

  def nl, do: e_nl

  def nonl, do: e_nonl

  ## scrollok

  def scrollok(win, flag) when is_integer(win) and is_boolean(flag) do
    case flag do
      :true -> e_scrollok(win, 1);
      :false -> e_scrollok(win, 0)
    end
  end

  ## hline/vline

  def hline(char, max_n) when is_integer(char) and is_integer(max_n) do
    e_hline(char, max_n)
  end

  def hline(win, char, max_n) when is_integer(win) and is_integer(char)
  and is_integer(max_n) do
    e_whline(win, char, max_n)
  end

  def vline(char, max_n) when is_integer(char) and is_integer(max_n) do
    e_vline(char, max_n)
  end

  def vline(win, char, max_n) when is_integer(win) and is_integer(char)
  and is_integer(max_n) do
    e_wvline(win, char, max_n)
  end

  ## border

  def border(ls, rs, ts, bs, tls, trs, bls, brs)
  when is_integer(ls) and is_integer(rs) and
  is_integer(ts) and is_integer(bs) and is_integer(tls) and
  is_integer(trs) and is_integer(bls) and is_integer(brs) do
    e_border(ls, rs, ts, bs, tls, trs, bls, brs)
  end

  def border(win, ls, rs, ts, bs, tls, trs, bls, brs)
  when is_integer(win) and is_integer(ls) and
  is_integer(rs) and is_integer(ts) and is_integer(bs) and
  is_integer(tls) and is_integer(trs) and is_integer(bls) and
  is_integer(brs) do
    e_wborder(win, ls, rs, ts, bs, tls, trs, bls, brs)
  end

  ## box

  def box(win, horz, vert) when is_integer(win) and is_integer(horz) and
  is_integer(vert) do
    e_box(win, horz, vert)
  end

  ## keypad

  def keypad(flag) when is_boolean(flag) do
    keypad(0, flag)
  end

  def keypad(win, flag) when is_integer(win) and is_boolean(flag) do
    case flag do
      :true -> e_keypad(win, 1);
      :false -> e_keypad(win, 0)
    end
  end

  ## getch

  def getch, do: getch(0)

  def getch(win) do
    e_wgetch(self(), win)
    receive do
      char -> char
    end
  end

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

  defp e_addstr(_str_len, _string), do: :not_initialized

  defp e_waddstr(_win, _str_len, _string), do: :not_initialized

  defp e_mvaddstr(_x, _y, _str_len, _string), do: :not_initialized

  defp e_mvwaddstr(_win, _x, _y, _str_len, _string), do: :not_initialized

  defp e_move(_x, _y), do: :not_initialized

  defp e_wmove(_win, _x, _y), do: :not_initialized

  defp e_getxy, do: :not_initialized

  defp e_wgetxy(_win), do: :not_initialized

  defp e_getmaxxy, do: :not_initialized

  defp e_wgetmaxxy(_win), do: :not_initialized

  defp e_curs_set(_flag), do: :not_initialized

  defp e_has_colors, do: :not_initialized

  defp e_start_color, do: :not_initialized

  defp e_init_pair(_n, _f_color, _b_color), do: :not_initialized

  defp e_attron(_mask), do: :not_initialized

  defp e_wattron(_win, _mask), do: :not_initialized

  defp e_attroff(_mask), do: :not_initialized

  defp e_wattroff(_win, _mask), do: :not_initialized

  defp e_nl, do: :not_initialized

  defp e_nonl, do: :not_initialized

  defp e_scrollok(_win, _flag), do: :not_initialized

  defp e_hline(_char, _max_n), do: :not_initialized

  defp e_whline(_win, _char, _max_n), do: :not_initialized

  defp e_vline(_char, _max_n), do: :not_initialized

  defp e_wvline(_win, _char, _max_n), do: :not_initialized

  defp e_border(_ls, _rs, _ts, _bs, _tls, _trs, _bls, _brs) do
    :not_initialized
  end

  defp e_wborder(_win, _ls, _rs, _ts, _bs, _tls, _trs, _bls, _brs) do
    :not_initialized
  end

  defp e_box(_win, _horz, _vert), do: :not_initialized

  defp e_keypad(_win, _flag), do: :not_initialized

  defp e_wgetch(_pid, _win), do: :not_initialized

end

