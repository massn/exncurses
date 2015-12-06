# ============================================================================
# Encurses 0.4.1
#
# Copyright © 2012 Jeff Zellner <jeff.zellner@gmail.com>. All Rights Reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
#   1. Redistributions of source code must retain the above copyright notice,
#      this list of conditions and the following disclaimer.
#   2. Redistributions in binary form must reproduce the above copyright
#      notice, this list of conditions and the following disclaimer in the
#      documentation and/or other materials provided with the distribution.
#   3. The name of the author may not be used to endorse or promote products
#      derived from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY AUTHOR "AS IS" AND ANY EXPRESS OR IMPLIED
# WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
# EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
# OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
# OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
# ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
# ============================================================================

defmodule Exncurses.Demo do
  require Quaff.Constants
  Quaff.Constants.include_lib("exncurses/include/encurses.hrl")

  def go do
    Exncurses.initscr
    Exncurses.keypad(0, :true)
    Exncurses.curs_set(@_CURS_INVISIBLE)
    Exncurses.erase
    Exncurses.refresh

    {mx, my} = Exncurses.getmaxxy
    str = 'Hello World! - encurses!'
    strLen = length(str)
    timer = :erlang.start_timer(10000, :main, :times_up)

    :erlang.spawn(__MODULE__, :keyloop, [])
    :erlang.spawn(__MODULE__, :other_win, [])
    :erlang.spawn(__MODULE__, :bounce_text, [str, strLen, 0, 0, 1, 1])
    :erlang.spawn(__MODULE__, :bounce_timer, [timer, div(mx, 2), div(my, 2), -1, 1])
    :erlang.register(:main, self)
    receive do
      {:timeout, ^timer, :times_up} ->
        Exncurses.erase
        Exncurses.refresh
        Exncurses.endwin
    end
  end

  def bounce_timer(timer, prev_x, prev_y, dir_x, dir_y) do
    str = :io_lib.format('~p', [:erlang.read_timer(timer)])
    Exncurses.move(prev_x, prev_y)
    Exncurses.hline(?\a, 4)
    {new_x, new_y, new_dir_x, new_dir_y} = calc_new_pos(4, prev_x, prev_y, dir_x, dir_y)
    Exncurses.mvaddstr(new_x, new_y, str)
    Exncurses.refresh
    :timer.sleep(20)
    bounce_timer(timer, new_x, new_y, new_dir_x, new_dir_y)
  end

  def bounce_text(str, str_len, prev_x, prev_y, dir_x, dir_y) do
    Exncurses.move(prev_x, prev_y)
    Exncurses.hline(?\s, length(str))
    {new_x, new_y, new_dir_x, new_dir_y} = calc_new_pos(str_len, prev_x, prev_y, dir_x, dir_y)
    Exncurses.mvaddstr(new_x, new_y, str)
    Exncurses.refresh
    :timer.sleep(100)
    bounce_text(str, str_len, new_x, new_y, new_dir_x, new_dir_y)
  end

  def calc_new_pos(len, px, py, dx, dy) do
    {mx, my} = Exncurses.getmaxxy
    {new_py, new_dy} =
    if (py + (dy) >= my) or (py + (dy) < 0) do
      {py + (dy * -1), dy * -1}
    else
      {py + (dy), dy}
    end
    {new_px, new_dx} =
    if (px + (dx) + len >= mx) or (px + (dx) < 0) do
      {px + (dx * -1), dx * -1}
    else
      {px + (dx), dx}
    end
    {new_px, new_py, new_dx, new_dy}
  end

  def other_win do
    win = Exncurses.newwin(5, 5, 5, 5)
    Exncurses.border(win, ?|, ?|, ?-, ?-, ?+, ?+, ?+, ?+)
    Exncurses.mvwaddstr(win, 1, 1, 'sup')
    Exncurses.mvwaddstr(win, 1, 2, 'sup')
    Exncurses.mvwaddstr(win, 1, 3, 'sup')
    Exncurses.refresh(win)
    :timer.sleep(100)
    other_win(win)
  end

  def other_win(win) do
    Exncurses.delwin(win)
    other_win
  end

  def refresh(win) do
    Exncurses.refresh(win)
    :timer.sleep(100)
    refresh(win)
  end

  def keyloop do
    Exncurses.noecho
    ch = Exncurses.getch
    Exncurses.mvaddstr(10, 10, '        ')
    Exncurses.mvaddstr(10, 10, :io_lib.format('~p', [parse_direction(ch)]))
    keyloop
  end

  def parse_direction(char) do
    case char do
      262 -> :kp_nw
      ?7 -> :kp_nw
      259 -> :kp_n
      ?8 -> :kp_nx
      339 -> :kp_ne
      ?9 -> :kp_ne
      260 -> :kp_w
      ?4 -> :kp_w
      350 -> :kp_center
      ?5 -> :kp_center
      261 -> :kp_e
      ?6 -> :kp_e
      360 -> :kp_sw
      ?1 -> :kp_sw
      258 -> :kp_s
      ?2 -> :kp_s
      338 -> :kp_se
      ?3 -> :kp_se
      other -> other
    end
  end
end


