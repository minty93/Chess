require_relative 'board'
require_relative 'display'

class Game

  attr_reader :display, :board

  def initialize
    @board = Board.new
    @display = Display.new(@board)
  end

  def run
    display.render
  end

end

if __FILE__ == $PROGRAM_NAME
  game = Game.new

  result = nil
  until result
    game.run
    result = game.display.get_input
  end
end
