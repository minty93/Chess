require_relative 'board'
require_relative 'display'

class Game

  attr_reader :display, :board, :player1, :player2

  def initialize(player1 = nil, player2 = nil)
    @player1 = player1 || HumanPlayer.new("White")
    @player2 = player2 || HumanPlayer.new("Black")
    @current_player = @player1
    @board = Board.new
    @display = Display.new(@board)
  end

  def run
    display.render
    until board.checkmate?(:white) || board.checkmate?(:black)
      get_player_move
      switch_players!
  end


  private
    attr_accessor :current_player

    def get_player_move
      display.get_input
    end

    def switch_players!
      self.current_player = current_player == player1 ? player2 : player1
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
