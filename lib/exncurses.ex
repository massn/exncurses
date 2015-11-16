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
    dir = 'priv'
    :erlang.load_nif(dir ++ '/encurses', 0)
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

