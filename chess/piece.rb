require 'byebug'

class Piece
  attr_reader :color, :board, :current_pos

  def initialize(color)
    @color = color
  end

  def moves(board, pos)
    @board = board
    @current_pos = pos
  end


  def to_s
    self.class.to_s
  end

end

class SlidingPiece < Piece

  def hits_piece?(move)
    board[*move].nil? ? false : board[*move].color
  end

  def get_direction(deltas)
    directions = []
    (1..7).each do |i|
      x = (direction.first * i) + current_pos.first
      y = (direction.last * i)  + current_pos.last
      possible_move = [x, y]

      case hits_piece?(possible_move)
      when false
        directions << possible_move
        next
      when self.color
        break
      else
        directions << possible_move
        break
      end
    end

    directions
  end
end

class Bishop < SlidingPiece
  DELTAS = [ [-1, -1], [-1, 1], [1, -1], [1, 1] ]


  def move_dirs
    moves = []
    DELTAS.each do |direction|
      moves += get_direction(direction)
    end

    moves
  end

end

class Rook < SlidingPiece

end

class Queen < SlidingPiece

end

class SteppingPiece < Piece

end

class Knight < SteppingPiece

end

class King < SteppingPiece

end

class Pawn < Piece

end
