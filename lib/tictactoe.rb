# frozen_string_literal: true

require_relative '../lib/game'
require_relative '../lib/board'
require_relative '../lib/player'
require_relative '../lib/string'

player1 = Player.new(1)
player2 = Player.new(2)
game = Game.new

game.start
