# Solves square Sudoku puzzles
#
# See http://en.wikipedia.org/wiki/Sudoku
class Sudoku

  attr_reader :board, :options
  
  def initialize(board, options = {})
    @board, @size, @options = board, Math.sqrt(board.size), { :values => (1..board.size).to_a, :blank => '.' }.merge(options)
    validate!
  end
  
  # Returns a new instance with a solved board
  def solve
    self.class.new(result, options)
  end
  
  # Solves this instance's board, returns self
  def solve!
    @board = result
    self
  end
  
  # Returns a string representation of the board
  def to_s
    max_value_size = options[:values].max { |a, b| a.size <=> b.size }
    board.inject([]) { |rows, row| rows << row.map { |value| (value || options[:blank]).to_s.rjust(max_value_size) }.join(' ') }.join("\n")
  end
  
  protected
  
    def result #:nodoc:
      solved_board = board.dup
      solved_board.each_with_index do |row, row_index|
        row.each_with_index do |cell, cell_index|
          next unless cell.nil?
          options[:values].each do |value|
            unless row.include?(value) || solved_board.any? { |r| r[cell_index] == value }
              solved_board[row_index][cell_index] = value
              break
            end
          end
        end
      end
    end
    
    def validate! #:nodoc:
      raise ArgumentError.new('Board must be square - e.g. 4x4, 9x9, 16x16, 25x25') unless @size == @size.to_i && board.all? { |row| row.size == board.size }
      raise ArgumentError.new("Must specify #{board.size} values for a #{board.size}x#{board.size} board") unless board.size == options[:values].size
    end
    
end