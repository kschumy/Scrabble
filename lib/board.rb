# QUESTION! how defensive do I need to be no my private methods?
module Scrabble
  class Board

    attr_reader :size

    def initialize(dimensions = 16)
      @size = 0
      @board = create_board(dimensions)
    end

    def print_board
      board_as_string = "----" * @size
      @board.each do |columns|
        row = "\n"
        columns.each do |element|
          element = " " if element.nil? # keeps alignment
          row = "#{row}| #{element} "
        end
        board_as_string << "#{row}|\n#{"----" * @size}"
      end
      return board_as_string
    end

    def add_word(row, col, word) #test if not a word
      valid_word_or_error(word)
      valid_coordinates_or_error(row, col)
      return fit_if_valid(row, col, word.upcase)
    end

    private

    def valid_word_or_error(word) # TODO: test for downcase ok
      if word.class != String || word.length < 1 || word.upcase.match?(/[^A-Z]+?/)
        raise ArgumentError.new("#{word} must be a String with only letters.")
      end
    end

    def fit_if_valid(row, col, word)
      row -= 1
      col -= 1
      if col + word.length <= @size && row + word.length <= @size
        return insert_across_or_down(row, col, word)
      elsif  col + word.length <= @size
        return insert_across(row, col, word)
      elsif row + word.length <= @size
        return insert_down(row, col, word)
      end
    end


    def insert_across_or_down(row, col, word)
      if rand(0..1) == 0 # Randomly picks a place to start
        return word if !insert_across(row, col, word).nil?
        return word if !insert_down(row, col, word).nil?
      else
        return word if !insert_down(row, col, word).nil?
        return word if !insert_across(row, col, word).nil?
      end
    end

    def insert_across(row, col, word)
      return if !has_space_across_for_word?(row, col, word)
      (0...word.length).each { |index| @board[row][col + index] = word[index] }
      return word
    end

    def has_space_across_for_word?(row, col, word)
      @board[row][col...word.length].each_with_index do |board_space, index|
        return if !board_space.nil? && board_space != word[index]
      end
      return word
    end

    def insert_down(row, col, word)
      return if !has_space_down_for_word?(row, col, word)
      (0...word.length).each { |index| @board[row + index][col] = word[index] }
      return word
    end

    def has_space_down_for_word?(row, col, word)
      word.length.times do |index|
        board_space = @board[row + index][col]
        return if !board_space.nil? && board_space != word[index]
      end
      return word
    end

    #
    def is_valid_coordinate?(coordinate)
      return coordinate.class == Integer && coordinate.between?(1, @size)
    end

    def valid_coordinates_or_error(row, column)
      if [row, column].any? { |coordinate| !is_valid_coordinate?(coordinate) }
        raise ArgumentError.new("#{coordinate} must be an int between 1-#{@size}")
      end
    end

    # Throws ArgumentError if provided dimensions are not a positive number.
    # Otherwise, creates new
    def create_board(dimensions)
      check_initial_dimension(dimensions)
      @size = dimensions
      return Array.new(dimensions) { Array.new(dimensions) }
    end

    # Throws ArgumentError if provided dimensions are not a positive number.
    def check_initial_dimension(dimensions)
      if dimensions.class != Integer || !dimensions.between?(1, 100) # TODO Test for this
        raise ArgumentError.new("Initial dimensions must be 1 and 100.")
      end
    end

  end
end
