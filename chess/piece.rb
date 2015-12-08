require 'byebug'


class Piece
  attr_reader :color # :board :current_pos
  attr_accessor :current_pos, :board

  def initialize(color, board, current_pos)
    @color = color
    @board = board
    @current_pos = current_pos
  end

  def moves(board, pos)
    @board = board
    @current_pos = pos
    valid_moves
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

    moves.select! do |move|
      move.all? {|coord| coord.between?(0,7)}
    end
    moves
  end

  def inspect
    to_s
  end

  def valid_moves
    possible_moves = move_dirs
    possible_moves.reject! do |move|
      board_state = board.dup

      board_state.move!(current_pos, move)
      board_state.in_check?(color)
    end

    possible_moves
  end
end
