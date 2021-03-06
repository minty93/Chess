require_relative 'pawn'
require_relative 'sliding_piece'
require_relative 'stepping_piece'
require_relative 'Exceptions'

class Board
  attr_accessor :selected_piece
  attr_reader :grid

  def initialize
    @grid = Array.new(8) { Array.new(8) }
    populate
  end

  def [](x, y)
    grid[y][x]
  end

  def []=(x, y, value)
    @grid[y][x] = value
  end

  def move(start, end_pos)

    valid_piece?(start)
    possible_moves = self[*start].moves(self, start)
    raise KingInCheckError if possible_moves.empty?

    legal_move?(end_pos, possible_moves)

    self[*end_pos] = self[*start]
    self[*start] = nil

    rescue NoPieceAtStartError => e
      puts "Please select a piece."
    rescue IllegalMoveError => e
      puts "Cannot move piece to that position"
    rescue KingInCheckError => e
      puts "Your King will be in check"
  end

  def move!(start, end_pos)
    self[*end_pos] = self[*start]
    self[*start] = nil
  end

  def legal_move?(desired_move, possible_moves)
    raise IllegalMoveError unless possible_moves.include?(desired_move)
  end

  def valid_piece?(start)
    raise NoPieceAtStartError if self[*start].nil?
  end

  def in_bounds?(pos)
    raise OutOfBoardError unless pos.all? { |coord| coord.between?(0, 7) }
    true
  end

  def in_check?(color)
    opposing_color = color == :black ? :white : :black
    king_pos = find_king(color)
    opposing_moves = find_moves_of(opposing_color)
    opposing_moves.include?(king_pos)
  end

  def checkmate?(color)
    return false unless in_check?(color)
    pieces = find_pieces(color)
    pieces.each do |piece_pos|
      return false unless self[*piece_pos].valid_moves.empty?
    end

    true
  end


  # private
    attr_writer :grid

    def find_king(color)
      grid.each.with_index do |row, i|
        row.each.with_index do |pos, j|
          return [j, i] if pos.class == King && pos.color == color
        end
      end
    end

    def find_moves_of(color)
      pieces = find_pieces(color)
      all_possible_moves = []

      pieces.each do |piece_pos|
        duped_board = dup
        duped_board[*piece_pos].board = duped_board
        duped_board[*piece_pos].current_pos = piece_pos
        all_possible_moves += duped_board[*piece_pos].move_dirs
      end
        all_possible_moves
    end

    def find_pieces(color)
      piece_positions = []
      grid.each.with_index do |row, i|
        row.each.with_index do |pos, j|
          piece_positions << [j, i] if pos && pos.color == color
        end
      end
      piece_positions
    end

    def populate
      8.times do |j|
        self[j, 1] = Pawn.new(:black, self, [j, 1])
        self[j, 6] = Pawn.new(:white, self, [j, 6])
      end

      @grid[0] = populate_pieces(:black, 0)
      @grid[7] = populate_pieces(:white, 7)
    end

    def populate_pieces(color, row)
      [
        Rook.new(color, self, [0, row]),
        Knight.new(color, self, [1, row]),
        Bishop.new(color, self, [2, row]),
        Queen.new(color, self, [3, row]),
        King.new(color, self, [4, row]),
        Bishop.new(color, self, [5, row]),
        Knight.new(color, self, [6, row]),
        Rook.new(color, self, [7, row])
      ]
    end

    def dup
      dup_board = Board.new
      dup_board.grid = grid.map do |row|
        row.map { |pos| pos.nil? ? nil : pos.dup }
      end

      dup_board
    end

end
