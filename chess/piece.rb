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

class Pawn < Piece
  WHITE_DELTAS = [

  ]

  BLACK_DELTAS = [

  ]

  def initialize(color)
    super(color)
    DELTAS = color == :black ? BLACK_DELTAS : WHITE_DELTAS
  end

  def move_dirs
    moves = []
    moves += check_forward_moves
    moves += check_diagonal_moves
  end

  def first_move?
    row = current_pos.last
    (row == 1 && color == :black) || (row == 6 && color == :white)
  end

  def check_forward_moves
    forward_moves = []
    x, y = current_pos[0], current_pos[1]
    if  !hits_piece?([x, (y+1)])
      forward_moves << [x, (y + 1)]
      forward_moves << [x, (y + 2)] if first_move? && !hits_piece?([x, y+2])
    end

    forward_moves
  end

  def check_diagonal_moves
    diagonal_moves = []
    x, y = current_pos[0], current_pos[1]

    right_diagonal = hits_piece?([x + 1, y+1])
    left_diagonal = hits_piece?([x-1, y+1])

    diagonal_moves << [x+1, y+1] if right_diagonal && right_diagonal != color
    diagonal_moves << [x-1, y+1] if left_diagonal && left_diagonal != color

    diagonal_moves
  end

  def to_s
    color == :black ? " ♟ " : " ♙ "
  end
end
