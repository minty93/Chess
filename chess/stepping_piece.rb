require_relative 'piece'

class SteppingPiece < Piece
  def get_direction(delta)
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

  def to_s
    color == :black ? " ♞ " : " ♘ "
  end

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

  def to_s
    color == :black ? " ♚ " : " ♔ "
  end

end
