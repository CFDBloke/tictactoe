# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

require_relative '../lib/player'

describe Player do
  subject(:player) { described_class.new(1) }

  context 'when player is first called from Game' do
    it 'has been instantiated as player1' do
      expect(player.number).to eq(1)
    end
  end

  context 'when player is called from Game for the second time' do
    subject(:player) { described_class.new(2) }

    it 'has been instantiated as player2' do
      expect(player.number).to eq(2)
    end
  end

  describe '#piece_input' do
    piece_choice = 'X'

    context 'when a player enters a valid piece' do
      before do
        allow(player).to receive(:gets).and_return(piece_choice)
        allow(player).to receive(:piece_valid?).and_return(true)
      end

      it 'returns the choice of piece' do
        other_piece = ''
        expect(player.piece_input(other_piece)).to eq(piece_choice)
      end
    end

    context 'when a player enters a piece already selected by the other player twice' do
      before do
        allow(player).to receive(:gets).and_return(piece_choice)
        allow(player).to receive(:piece_valid?).and_return(false, false, true)
      end

      it 'completes loop and displays error message twice' do
        other_piece = 'X'
        error_message = "You can't use #{other_piece}... try again..."
        expect(player).to receive(:puts).with(error_message).twice
        player.piece_input(other_piece)
      end
    end
  end

  describe '#truncate_piece' do
    context 'when a player enters a single character' do
      player_input = 'O'

      before do
        allow(player).to receive(:gets).and_return(player_input)
      end

      it 'does not display the warning message' do
        warning_message = "\nYou can only enter one character, using only the first character, #{player_input[0]}!"
        expect(player).not_to receive(:puts).with(warning_message)
        player.truncate_piece
      end

      it 'returns the inputted character' do
        expect(player.truncate_piece).to eq(player_input)
      end
    end

    context 'when a player enters multiple characters' do
      player_input = 'Ojkdjr'
      chosen_piece = 'O'

      before do
        allow(player).to receive(:gets).and_return(player_input)
        allow(player).to receive(:puts).once
      end

      it 'outputs the warning message' do
        warning_message = "\nYou can only enter one character, using only the first character, #{chosen_piece}!"
        expect(player).to receive(:puts).with(warning_message)
        player.truncate_piece
      end

      it 'returns the first character of the inputted string' do
        expect(player.truncate_piece).to eq(chosen_piece)
      end
    end
  end

  describe '#color_input' do
    context 'player enters a valid color choice as a number' do
      player_input = '2'

      before do
        allow(player).to receive(:gets).and_return(player_input)
      end

      it 'returns the color code as an integer' do
        expect(player.color_input).to eql(32)
      end

      it 'does not return the error message' do
        error_message = "\nInvalid choice!!"
        expect(player).not_to receive(:puts).with(error_message)
      end
    end

    context 'player enters a valid color choice as a string' do
      player_input = 'Green'

      before do
        allow(player).to receive(:gets).and_return(player_input)
      end

      it 'returns the color code as an integer' do
        expect(player.color_input).to eql(32)
      end

      it 'does not return the error message' do
        error_message = "\nInvalid choice!!"
        expect(player).not_to receive(:puts).with(error_message)
      end
    end

    context 'player enters an invalid color choice twice' do
      invalid_input1 = '9'
      invalid_input2 = 'Indigo'
      valid_input = 'Blue'

      before do
        allow(player).to receive(:gets).and_return(invalid_input1, invalid_input2, valid_input)
        allow(player).to receive(:puts).twice
      end

      it 'returns the color code as an integer' do
        expect(player.color_input).to eql(34)
      end

      it 'displays the error message twice' do
        error_message = "\nInvalid choice!!"
        expect(player).to receive(:puts).with(error_message).twice
        player.color_input
      end
    end
  end
end
