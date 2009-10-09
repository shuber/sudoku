# Solves square Sudoku puzzles
#
# See http://en.wikipedia.org/wiki/Sudoku
class Sudoku
  
  attr_reader :board, :values, :blank
  
  def initialize(board, values = nil, blank = '.')
    @board, @values, @blank, @size = board, values || (1..board.size).to_a, blank, Math.sqrt(board.size)
    validate!
  end
  
  # Returns a new instance with a solved board
  def solve
    self.class.new(result, @values, @blank)
  end
  
  # Solves this instance's board, returns self
  def solve!
    @board = result
    self
  end
  
  def to_s
    @board.inject([]) { |rows, row| rows << row.map { |value| value || @blank }.join(' ') }.join("\n")
  end
  
  protected
  
    def result # :nodoc:
      board = @board
    end
    
    def validate!
      raise ArgumentError.new('Board must be square - e.g. 4x4, 9x9, 16x16, 25x25') unless @size == @size.to_i && @board.all? { |row| row.size == @board.size }
      raise ArgumentError.new("Must specify #{@board.size} values for a #{@board.size}x#{@board.size} board") unless @board.size == @values.size
    end
    
end