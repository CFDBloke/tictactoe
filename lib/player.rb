# frozen_string_literal: true

# The player class that defines the details
class Player
  attr_reader :number, :piece, :color

  def initialize(number)
    @number = number
    @name = ''
    @color = 39
    @piece = ''
  end

  def setup(other_piece = '')
    @name = request_name
    @color = request_color
    @piece = request_piece(other_piece)
  end

  def name
    @name.colorize(@color)
  end

  def request_name
    puts "\nPlayer #{@number}: Please enter your name (keep it clean please!)"

    gets.chomp.capitalize
  end

  def request_color
    colors = { '1' => 'Red', '2' => 'Green', '3' => 'Yellow', '4' => 'Blue', '5' => 'Pink', '6' => 'Light Blue' }

    puts "\n#{@name} please choose the colour of your playing piece from the list below\n"

    colors.each_pair { |key, value| puts "#{key}: #{value}".colorize(get_color_code(value.downcase)) }
  end

  def request_piece(other_piece = nil)
    puts "\nHello #{@name}, please enter a single character to represent your playing piece"

    puts other_piece.nil? ? '' : "You can't use #{other_piece}"

    choice = gets.chomp

    if choice.length > 1
      puts "\nYou can only enter one character, using only the first character, #{choice[0]}!"
      choice = choice[0]
    end

    piece_choice_valid(choice, other_piece) ? choice : request_piece(other_piece)
  end

  private

  def color_input
    loop do
      choice = get_color_code(gets.downcase.chomp)
      return choice if choice.nil? == false

      puts "\nInvalid choice!!"
    end
  end

  def get_color_code(color)
    codes = { 'red' => 31, 'green' => 32, 'yellow' => 33, 'blue' => 34, 'pink' => 35, 'light blue' => 36,
              '1' => 31, '2' => 32, '3' => 33, '4' => 34, '5' => 35, '6' => 36 }
    codes[color] if codes.key?(color)
  end

  def piece_choice_valid(choice, other_piece)
    if choice == other_piece
      puts "You can't use #{other_piece}... try again..."
      false
    else
      true
    end
  end
end
