require_relative 'piece'

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

  def to_s
    color == :black ? " ♝ " : " ♗ "
  end

end

class Rook < SlidingPiece
  DELTAS = [ [-1, 0], [0, -1], [1, 0], [0, 1] ]

  def to_s
    color == :black ? " ♜ " : " ♖ "
  end

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

  def to_s
    color == :black ? " ♛ " : " ♕ "
  end

end
