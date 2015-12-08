require 'byebug'


class Piece
  attr_reader :color, :board, :current_pos

  def initialize(color)
    @color = color
  end

  def moves(board, pos)
    @board = board
    @current_pos = pos
    move_dirs
  end


  def to_s
    self.class.to_s[0..2]
  end

  def hits_piece?(move)
    board.in_bounds?(move)

    board[*move].nil? ? false : board[*move].color

    rescue OutOfBoardError => e
      false
  end

  def move_dirs
    moves = []
    self.class::DELTAS.each do |delta|
      moves.concat(get_direction(delta))
    end

    moves
  end

  def inspect
    to_s
  end
end
