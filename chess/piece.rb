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

  def hits_piece?(move)
    board[*move].nil? ? false : board[*move].color
  end

  def move_dirs
    moves = []
    self.class::DELTAS.each do |delta|
      moves += get_direction(delta)
    end

    moves
  end
end

class SlidingPiece < Piece

  def get_direction(delta)
    directions = []
    (1..7).each do |i|
      x = (delta.first * i) + current_pos.first
      y = (delta.last * i)  + current_pos.last
      possible_move = [x, y]

      case hits_piece?(possible_move)
      when false
        directions << possible_move
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

end

class Rook < SlidingPiece
  DELTAS = [ [-1, 0], [0, -1], [1, 0], [0, 1] ]

end

class Queen < SlidingPiece
  DELTAS = [
  [-1, -1],
  [-1,  1],
  [ 1, -1],
  [ 1,  1],
  [-1,  0],
  [ 0, -1],
  [ 1,  0],
  [ 0,  1]
  ]

end

class SteppingPiece < Piece


  def get_direction(step)
    x = delta.first + current_pos.first
    y = delta.last  + current_pos.last
    possible_move = [x, y]

    hits_piece?(possible_move) != self.color ? [possible_move] : []
  end
end

class Knight < SteppingPiece
  DELTAS = [
  [-1, -2],
  [-1,  2],
  [ 1, -2],
  [ 1,  2],
  [-2, -1],
  [-2,  1],
  [ 2, -1],
  [ 2,  1]
  ]
end

class King < SteppingPiece
  DELTAS = [
  [-1, -1],
  [-1,  1],
  [ 1, -1],
  [ 1,  1],
  [-1,  0],
  [ 0, -1],
  [ 1,  0],
  [ 0,  1]
  ]

end

class Pawn < Piece

end
