
require "colorize"
require_relative "cursorable"
require_relative 'board'

class Display
  include Cursorable

  attr_reader :board, :cursor_pos, :selected, :selected_pos

  def initialize(board)
    @board = board
    @cursor_pos = [0, 0]
    @selected = false
    @selected_pos = nil
  end

  def build_grid
    board.grid.map.with_index do |row, i|
      build_row(row, i)
    end
  end

  def build_row(row, i)
    row.map.with_index do |piece, j|
      color_options = colors_for(i, j)
      if piece
        piece.to_s.colorize(color_options)
      else
        "   ".colorize(color_options)
      end
    end
  end

  def colors_for(i, j)
    if [i, j] == @cursor_pos
      bg = :light_red
    elsif (i + j).odd?
      bg = :light_black
    else
      bg = :light_gray
    end
    #color = board[j, i].nil? ? :black : :black
    { background: bg, color: :black }
  end

  def render
    system("clear")
    build_grid.each { |row| puts row.join }
  end
end
