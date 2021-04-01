# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

require_relative '../lib/board'
require_relative '../lib/player'

describe Board do
  subject(:board) { described_class.new }

  it 'has been instantiated' do
    expect(board).to be_a(Board)
  end

  describe '#update_board' do
    context 'when a player makes a choice on a fresh board' do
      let(:player) { instance_double(Player, piece: 'X', color: 32) }

      it 'is registered on the board' do
        choice = '1'
        board.update_board(player, choice)
        board_var = board.instance_variable_get(:@board)
        expect(board_var[0]).to eql(player.piece)
      end
    end

    context 'when a player makes a choice on a non-fresh board' do
      let(:player) { instance_double(Player, piece: 'X', color: 32) }

      before do
        board.instance_variable_set(:@board, %w[X O O 4 5 X O X 9])
      end

      it 'is registered on the board' do
        choice = '4'
        board.update_board(player, choice)
        board_var = board.instance_variable_get(:@board)
        expect(board_var[3]).to eql(player.piece)
      end
    end
  end

  describe '#update_winning_combos' do
    context 'when a player makes a choice on a fresh board' do
      let(:player) { instance_double(Player, piece: 'X', color: 32) }

      it 'is registered in the winning combos variable' do
        choice = '1'
        board.update_winning_combos(player, choice)
        winning_combos = board.instance_variable_get(:@winning_combos)
        expect(winning_combos[0]).to eq(%w[X 2 3])
        expect(winning_combos[3]).to eq(%w[X 4 7])
        expect(winning_combos[6]).to eq(%w[X 5 9])
      end
    end

    context 'when a player makes a choice on a non-fresh board' do
      let(:player) { instance_double(Player, piece: 'O', color: 34) }

      before do
        board.instance_variable_set(:@winning_combos,
                                    [%w[X 2 X], %w[4 O 6], %w[7 8 9], %w[X 4 7],
                                     %w[2 O 8], %w[X 6 9], %w[X O 9], %w[X O 7]])
      end

      it 'is registered in the winning combos variable' do
        choice = '2'
        board.update_winning_combos(player, choice)
        winning_combos = board.instance_variable_get(:@winning_combos)
        expect(winning_combos[0]).to eq(%w[X O X])
        expect(winning_combos[4]).to eq(%w[O O 8])
      end
    end
  end

  describe '#winner' do
    context 'a winner has not yet been established' do
      it 'returns a blank string' do
        piece = 'X'
        expect(board.winner(piece)).to eq('')
      end
    end

    context 'the piece just played belongs to the winning player' do
      before do
        board.instance_variable_set(:@winning_combos,
                                    [%w[X O X], %w[4 O X], %w[7 O 9], %w[X 4 7],
                                     %w[O O O], %w[X X 9], %w[X O 9], %w[X O 7]])
      end

      it 'returns the original piece' do
        piece = 'O'
        expect(board.winner(piece)).to eq(piece)
      end
    end
  end

  describe '#determine_winner' do
    let(:player1) { instance_double(Player, number: 1, piece: 'X', color: 34) }
    let(:player2) { instance_double(Player, number: 2, piece: 'O', color: 32) }

    context 'player1 is the winner' do
      before do
        board.instance_variable_set(:@winning_piece, 'X')
      end

      it 'returns player1' do
        expect(board.determine_winner(player1, player2)).to eql(player1)
      end
    end

    context 'player2 is the winner' do
      before do
        board.instance_variable_set(:@winning_piece, 'O')
      end

      it 'returns player2' do
        expect(board.determine_winner(player1, player2)).to eql(player2)
      end
    end
  end
end
