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

    debugger

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
  attr_reader :direction

  def initialize(color)
    super(color)
    # DELTAS = color == :black ? BLACK_DELTAS : WHITE_DELTAS
    @direction = color == :white ? -1 : 1
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
    x, y = current_pos
    forward_one = [x, y + direction]
    forward_two = [x, y + (direction * 2)]

    forward_moves = []
    unless hits_piece?(forward_one)
      forward_moves << forward_one
      forward_moves << forward_two if first_move? && !hits_piece?(forward_two)
    end

    forward_moves
  end

  def check_diagonal_moves
    diagonal_moves = []
    x, y = current_pos
    diagonal_left  = [x - direction, y + direction]
    diagonal_right = [x + direction, y + direction]

    enemy_left = hits_piece?(diagonal_left)
    enemy_right = hits_piece?(diagonal_left)

    diagonal_moves << diagonal_right if enemy_right && enemy_right != color
    diagonal_moves << diagonal_left  if enemy_left && enemy_left   != color

    diagonal_moves
  end

  def to_s
    color == :black ? " ♟ " : " ♙ "
  end

end
