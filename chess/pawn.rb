require_relative 'piece'

class Pawn < Piece
  attr_reader :direction

  def initialize(color, board, pos)
    super(color, board, pos)
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
