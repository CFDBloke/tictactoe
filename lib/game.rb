# frozen_string_literal: true

# The main game class which handles all program control
class Game
  attr_reader :player1, :player2, :board

  def initialize
    @player1 = nil
    @player2 = nil
    @board = nil
  end

  def start
    puts "\n\n**** WELCOME TO TICTACTOE!! ****\n\n"

    @player1 = Player.new(1)
    @player2 = Player.new(2)

    @player1.setup
    @player2.setup(@player1.piece)

    play_new_board
  end

  private

  def play_new_board
    @board = Board.new

    confirm_play_start

    execute_game_play

    confirm_play_end(@board.determine_winner(@player1, @player2))

    confirm_play_again
  end

  def execute_game_play
    until game_over?
      place_piece(@player1)
      place_piece(@player2)
    end
  end

  def game_over?
    @board.winning_piece != ''
  end

  def place_piece(player)
    return unless @board.winning_piece == ''

    puts "#{player.name}, please choose your play by entering a number...".colorize(player.color)

    play_result = @board.register_play(player, gets.chomp)

    assess_play(player, play_result)
  end

  def assess_play(player, play_result)
    if play_result == :no_play
      replay(player)
    else
      @board.drawboard
      @board.winning_piece = play_result == :draw ? 'draw' : @board.winner(player.piece)
    end
  end

  def replay(player)
    puts 'That board position has already been played, try again...'
    place_piece(player)
  end

  def confirm_play_start
    puts 'Ok, let\'s play...'
    puts "#{@player1.name}, #{@player2.name}... may the best player win!!"
    @board.drawboard
  end

  def confirm_play_end(player)
    if player == :draw
      puts "It's a draw!!"
    else
      puts "Congratulations #{player.name}, you won!".colorize(player.color)
    end
  end

  def confirm_play_again
    puts "Would you like a re-match? (enter 'y' or 'n')"

    choice = play_again_input

    choice == 'y' ? play_new_board : (puts 'Ok, thanks for playing! See you again soon!!')
  end

  def play_again_input
    loop do
      user_input = gets.chomp.downcase
      verified_input = verify_play_again_input(user_input)
      return verified_input if verified_input

      puts 'Sorry, I didn\'t quite catch that... please try again...'
    end
  end

  def verify_play_again_input(input)
    input = input.initial
    return input if %w[y n].any?(input)
  end
end
