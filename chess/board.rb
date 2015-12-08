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
    valid_move?(end_pos, possible_moves)

    self[*end_pos] = self[*start]
    self[*start] = nil

    rescue NoPieceAtStartError => e
      puts "Please select a piece."
    rescue InvalidMoveError => e
      puts "Cannot move piece to that position"
  end

  def valid_move?(desired_move, possible_moves)
    raise InvalidMoveError unless possible_moves.include?(desired_move)

  end

  def valid_piece?(start)
    raise NoPieceAtStartError if self[*start].nil?
  end

  def in_bounds?(pos)
    raise OutOfBoardError unless pos.all? { |coord| coord.between?(0, 7) }
    true
  end

  private
    def populate
      8.times do |j|
        self[j, 1] = Pawn.new(:black)
        self[j, 6] = Pawn.new(:white)
      end

      @grid[0] = populate_pieces(:black, 0)
      @grid[7] = populate_pieces(:white, 7)
    end

    def populate_pieces(color, row)
      [
        Rook.new(color),
        Knight.new(color),
        Bishop.new(color),
        Queen.new(color),
        King.new(color),
        Bishop.new(color),
        Knight.new(color),
        Rook.new(color)
      ]
    end
end
