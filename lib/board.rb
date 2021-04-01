# frozen_string_literal: true

# The class for the tictactoe game board
class Board
  attr_accessor :winning_piece

  def initialize
    @winning_piece = ''
    @board = %w[1 2 3 4 5 6 7 8 9]
    @colors = [39, 39, 39, 39, 39, 39, 39, 39, 39]
    @winning_combos = [%w[1 2 3], %w[4 5 6], %w[7 8 9], %w[1 4 7], %w[2 5 8], %w[3 6 9], %w[1 5 9], %w[3 5 7]]
  end

  def drawboard
    drawboard_top
    drawboard_middle
    drawboard_bottom
  end

  def register_play(player, choice)
    return :no_play if @board.none? choice

    confirm_register(player, choice)
  end

  def winner(piece)
    is_win = @winning_combos.reduce(false) do |winner, winning_combo|
      winner || winning_combo.all? { |value| value == piece }
    end
    is_win ? piece : ''
  end

  def determine_winner(player1, player2)
    if player1.piece == @winning_piece
      player1
    elsif player2.piece == @winning_piece
      player2
    else
      :draw
    end
  end

  private

  def confirm_register(player, choice)
    update_board(player, choice)

    update_winning_combos(player, choice)

    @colors[choice.to_i - 1] = player.color

    return :draw if @colors.none?(39)
  end

  def update_board(player, choice)
    @board = @board.map { |value| choice == value ? player.piece : value }
  end

  def update_winning_combos(player, choice)
    @winning_combos = @winning_combos.map do |winning_combo|
      winning_combo.map { |value| choice == value ? player.piece : value }
    end
  end

  def drawboard_top
    puts '     '
    puts '      ||===========||'
    puts "      || #{@board[0].colorize(@colors[0])} | #{@board[1].colorize(@colors[1])} | "\
                  "#{@board[2].colorize(@colors[2])} ||"
  end

  def drawboard_middle
    puts '      ||---+---+---||'
    puts "      || #{@board[3].colorize(@colors[3])} | #{@board[4].colorize(@colors[4])} | "\
                  "#{@board[5].colorize(@colors[5])} ||"
    puts '      ||---+---+---||'
  end

  def drawboard_bottom
    puts "      || #{@board[6].colorize(@colors[6])} | #{@board[7].colorize(@colors[7])} | "\
                  "#{@board[8].colorize(@colors[8])} ||"
    puts '      ||===========||'
    puts '     '
  end
end
