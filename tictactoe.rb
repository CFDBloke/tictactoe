# frozen_string_literal: false

require 'pry'

# Module of methods that provide all of the player details to the program
module PlayerDetails
  def get_name(num)
    puts "\nPlayer #{num}: Please enter your name (keep it clean please!)"

    gets.chomp
  end

  def get_piece(name, other_piece = nil)
    puts "\nHello #{name}, please enter a single character to represent your playing piece"

    puts other_piece.nil? ? '' : "You can't use #{other_piece}"

    choice = gets.chomp

    if choice.length > 1
      puts "\nYou can only enter one character, using only the first character, #{choice[0]}!"
      choice = choice[0]
    end

    piece_choice_valid(choice, other_piece) ? choice : get_piece(name, other_piece)
  end

  def get_color(name)
    colors = { '1' => 'Red', '2' => 'Green', '3' => 'Yellow', '4' => 'Blue', '5' => 'Pink', '6' => 'Light Blue' }

    puts "\n#{name} please choose the colour of your playing piece from the list below\n"

    colors.each_pair { |key, value| puts "#{key}: #{value}".colorize(get_color_code(value.downcase)) }

    choice = get_color_code(gets.downcase.chomp)

    if choice.nil? == false
      choice
    else
      puts "\nInvalid choice!!"
      get_color(name)
    end
  end

  def get_color_code(color)
    codes = { 'red' => 31, 'green' => 32, 'yellow' => 33, 'blue' => 34, 'pink' => 35, 'light blue' => 36,
              '1' => 31, '2' => 32, '3' => 33, '4' => 34, '5' => 35, '6' => 36 }
    codes[color] if codes.key?(color)
  end

  private

  def piece_choice_valid(choice, other_piece)
    if choice == other_piece
      puts "I said, you can't use #{other_piece}... try again..."
      false
    else
      true
    end
  end
end

# An addon to the String class to change the colour of the text
class String
  def colorize(color_code)
    "\e[#{color_code}m#{self}\e[0m"
  end
end

def play(board, player)
  board.drawboard

  return unless board.winning_piece == ''

  puts "#{player.name}, please choose your play by entering a number..."

  play_choice = gets.chomp

  board.register_play(player, play_choice)

  board.winning_piece = board.winner?(player.piece)
end

# The class for the tictactoe game board
class Board
  include PlayerDetails

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
    @board = @board.map { |value| choice == value ? player.piece : value }

    @winning_combos = @winning_combos.map do |winning_combo|
      winning_combo.map { |value| choice == value ? player.piece : value }
    end

    @colors[choice.to_i - 1] = player.color
  end

  def winner?(piece)
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
    end
  end

  private

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

# The player class that defines the details
class Player
  attr_reader :name, :piece, :color

  def initialize(name, piece, color)
    @name = name.capitalize
    @piece = piece
    @color = color
  end
end

# The main game class which handles all program control
class Game
  include PlayerDetails
  def start
    puts "\n\n**** WELCOME TO TICTACTOE!! ****\n\n"

    player1 = create_player(1)
    player2 = create_player(2, player1.piece)

    confirm_play_start(player1, player2)

    board = Board.new
    until board.winning_piece != ''
      play(board, player1)
      play(board, player2)
    end

    confirm_end(board.determine_winner(player1, player2))
  end

  private

  def create_player(num, other_piece = nil)
    name = get_name(num)
    Player.new(name, get_piece(name, other_piece), get_color(name))
  end

  def confirm_play_start(player1, player2)
    puts 'Ok, let\'s play...'
    puts "#{player1.name.colorize(player1.color)}, #{player2.name.colorize(player2.color)}... may the best player win!!"
  end

  def confirm_end(player)
    puts "Congratulations #{player.name}, you won!".colorize(player.color)
  end
end

game = Game.new

game.start
