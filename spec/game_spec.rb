# frozen_string_literal: true

require_relative '../lib/game'
require_relative '../lib/board'
require_relative '../lib/player'
require_relative '../lib/string'

describe Game do
  subject(:new_game) { described_class.new }

  it 'has been instantiated' do
    expect(new_game).to be_a(Game)
  end

  it 'and is truthy' do
    expect(new_game).to be_truthy
  end

  describe '#initialize' do
    context 'when first initialised' do
      it 'has a player1 instance variable with nil value' do
        expect(new_game.player1).to be_nil
      end

      it 'has a player2 instance variable with nil value' do
        expect(new_game.player2).to be_nil
      end

      it 'has a board instance variable with nil value' do
        expect(new_game.board).to be_nil
      end
    end
  end

  describe '#game_over?' do
    context 'when a player has got three of their pieces in a row' do
      let(:board) { instance_double(Board, winning_piece: 'X') }

      before { new_game.instance_variable_set(:@board, board) }

      it 'is game over' do
        expect(new_game).to be_game_over
      end
    end

    context 'when all available turns are gone and there is no winner' do
      let(:board) { instance_double(Board, winning_piece: 'draw') }

      before { new_game.instance_variable_set(:@board, board) }

      it 'is a draw' do
        expect(new_game).to be_game_over
      end
    end
  end

  describe '#confirm_play_end' do
    context 'when the game ends without a clear winner' do
      it 'is a draw' do
        player = :draw
        expect(new_game).to receive(:puts).with("It's a draw!!")
        new_game.confirm_play_end(player)
      end
    end

    context 'when the game ends with a winner' do
      it 'bob wins and his piece colour is blue' do
        player = instance_double(Player, name: 'Bob', color: 34)
        expect(new_game).to receive(:puts).with("Congratulations #{player.name}, you won!".colorize(player.color))
        new_game.confirm_play_end(player)
      end
    end
  end

  describe '#play_again_input' do
    context 'when the players do want a re-match' do
      before do
        valid_input = 'y'
        allow(new_game).to receive(:puts)
        allow(new_game).to receive(:gets).and_return(valid_input)
      end

      it 'stops loop and does not display error message' do
        error_message = 'Sorry, I didn\'t quite catch that... please try again...'
        expect(new_game).not_to receive(:puts).with(error_message)
        new_game.play_again_input
      end
    end

    context 'when the player inputs an invalid value once' do
      before do
        invalid_input = 'a'
        valid_input = 'y'
        allow(new_game).to receive(:puts)
        allow(new_game).to receive(:gets).and_return(invalid_input, valid_input)
      end

      it 'completes the loop and displays the error message once' do
        error_message = 'Sorry, I didn\'t quite catch that... please try again...'
        expect(new_game).to receive(:puts).with(error_message).once
        new_game.play_again_input
      end
    end
  end
end
