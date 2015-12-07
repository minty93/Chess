require_relative 'piece'
require_relative 'Exceptions'

class Board
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

    valid_move?(start)

    self[*end_pos] = self[*start]
    self[*start] = nil

    rescue NoPieceAtStartError => e
      puts "Please select a piece."
  end

  def valid_move?(start)
    raise NoPieceAtStartError if self[*start].nil?
  end

  def in_bounds?(pos)
    raise OutofBoardError unless pos.all? { |coord| coord.between?(0, 7) }
    true
  end

  private
    def populate
      (0..1).each do |i|
        8.times do |j|
          self[j, i] = Piece.new(:black)
        end
      end

      (6..7).each do |i|
        8.times do |j|
          self[j, i] = Piece.new(:cyan)
        end
      end

    end
end
