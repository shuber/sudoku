module Sudoku
  # Solves traditional square Sudoku puzzles
  #
  # See http://en.wikipedia.org/wiki/Sudoku
  #
  # Example:
  #
  #   unsolved_puzzle = [
  #     [  2, nil, nil, nil, nil,   1, nil,   3,   8],
  #     [nil, nil, nil, nil, nil, nil, nil, nil,   5],
  #     [nil,   7, nil, nil, nil,   6, nil, nil, nil],
  #     [nil, nil, nil, nil, nil, nil, nil,   1,   3],
  #     [nil,   9,   8,   1, nil, nil,   2,   5,   7],
  #     [  3,   1, nil, nil, nil, nil,   8, nil, nil],
  #     [  9, nil, nil,   8, nil, nil, nil,   2, nil],
  #     [nil,   5, nil, nil,   6,   9,   7,   8,   4],
  #     [  4, nil, nil,   2,   5, nil, nil, nil, nil]
  #   ]
  #   
  #   sudoku = Sudoku::Puzzle.new(unsolved_puzzle, :blank => '.')
  #   
  #   puts sudoku.puzzle
  #   # 2 . . . . 1 . 3 8
  #   # . . . . . . . . 5
  #   # . 7 . . . 6 . . .
  #   # . . . . . . . 1 3
  #   # . 9 8 1 . . 2 5 7
  #   # 3 1 . . . . 8 . .
  #   # 9 . . 8 . . . 2 .
  #   # . 5 . . 6 9 7 8 4
  #   # 4 . . 2 5 . . . .
  #   
  #   puts sudoku.solve!.puzzle
  #   # 2 4 9 5 7 1 6 3 8
  #   # 8 6 1 4 3 2 9 7 5
  #   # 5 7 3 9 8 6 1 4 2
  #   # 7 2 5 6 9 8 4 1 3
  #   # 6 9 8 1 4 3 2 5 7
  #   # 3 1 4 7 2 5 8 6 9
  #   # 9 3 7 8 1 4 5 2 6
  #   # 1 5 2 3 6 9 7 8 4
  #   # 4 8 6 2 5 7 3 9 1
  class Puzzle
    
    attr_reader :puzzle
    
    # Accepts a puzzle as an array of rows and an optional hash of options
    #
    # The options are:
    #
    #   :values      - An array of values to fill the puzzle with. Defaults to an array
    #                  containing the numbers 1 to the size of the puzzle. For example,
    #                  a 9x9 puzzle would have [1,2,3,4,5,6,7,8,9] as its default values.
    #   :blank       - The string to use for nil values when printing out the puzzle as a string.
    #                  Defaults to a period.
    #
    # Example:
    #
    #   unsolved_puzzle = [
    #     [  2, nil, nil, nil, nil,   1, nil,   3,   8],
    #     [nil, nil, nil, nil, nil, nil, nil, nil,   5],
    #     [nil,   7, nil, nil, nil,   6, nil, nil, nil],
    #     [nil, nil, nil, nil, nil, nil, nil,   1,   3],
    #     [nil,   9,   8,   1, nil, nil,   2,   5,   7],
    #     [  3,   1, nil, nil, nil, nil,   8, nil, nil],
    #     [  9, nil, nil,   8, nil, nil, nil,   2, nil],
    #     [nil,   5, nil, nil,   6,   9,   7,   8,   4],
    #     [  4, nil, nil,   2,   5, nil, nil, nil, nil]
    #   ]
    #   sudoku = Sudoku::Puzzle.new(unsolved_puzzle, :blank => 'x')
    def initialize(puzzle, options = {})
      @puzzle = puzzle
      self.options.merge!(options)
      validate_arguments!
    end
    
    def [](row, column)
      puzzle[row][column]
    end
    
    def []=(row, column, value)
      puzzle[row][column] = value
    end
    
    # Returns the values associated with a column
    def column(index)
      columns[index]
    end
    
    # Returns an array of values associated with each column of the puzzle
    def columns
      puzzle.transpose
    end
    
    # Returns the size of the longest member in optinos[:values]
    # This is used by <tt>puzzle</tt> to make sure the columns are printed out evenly
    def max_value_size
      @max_value_size ||= options[:values].max { |a, b| a.size <=> b.size }.size
    end
    
    # Returns a hash of options for this instance
    def options
      @options ||= { :values => (1..puzzle.size).to_a, :blank => '.' }
    end
    
    # Returns the values associated with a row
    def row(index)
      puzzle[index]
    end
    
    # Returns the size of this puzzle's sections
    #
    # Example:
    #
    #   sudoku = Sudoku::Puzzle.new(puzzle_9x9)
    #   sudoku.section_size # => 3
    def section_size
      @section_size ||= Math.sqrt(puzzle.size).to_i
    end
    
    # Returns an array of coordinates corresponding to each section
    #
    # Example:
    #
    #   sudoku = Sudoku::Puzzle.new(puzzle_9x9)
    #   sudoku.sections[0] # => [[0,0], [0,1], [0,2], [1,0], [1,1], [1,2], [2,0], [2,1], [2,2]]
    def sections
      (1..section_size).inject([]) do |array, row_offset|
        (1..section_size).inject(array) do |array, column_offset|
          array << section_coordinates(row_offset - 1, column_offset - 1)
        end
      end
    end
    
    # Solves this instance's puzzle, returns self
    def solve!
      solve
      self
    end
    
    # Returns a string representation of the puzzle
    def to_s
      puzzle.inject([]) { |rows, row| rows << row.map { |value| (value || options[:blank]).to_s.rjust(max_value_size) }.join(' ') }.join("\n")
    end
    
    # Checks if this puzzle has been solved correctly
    def valid?
      1.upto(puzzle.size) { |index| return false unless valid_row?(index - 1) && valid_column?(index - 1) }
      sections.all? { |section| valid_section?(section) }
    end
    
    # Checks if all values are filled in and unique for the column at the specified <tt>index</tt>.
    def valid_column?(index)
      column_values = column(index).compact
      column_values == column_values.uniq
    end
    
    # Checks if all values are filled in and unique for the row at the specified <tt>index</tt>.
    def valid_row?(index)
      row_values = row(index).compact
      row_values == row_values.uniq
    end
    
    # Checks if all values are filled in and unique in the array of coordinates specified.
    def valid_section?(section)
      values(section).compact.sort == options[:values].sort
    end
    
    # Returns an array of the values associated with an array of coordinates
    def values(coords)
      coords.collect { |coord| self[*coord] }
    end
    
    protected
    
      # Returns an array of coordinates for the section starting at the specified <tt>row_offset</tt> and <tt>column_offset</tt>
      def section_coordinates(row_offset, column_offset)
        row_start = row_offset * section_size
        row_end = row_start + section_size - 1
        column_start = column_offset * section_size
        column_end = column_start + section_size - 1
        ((row_start..row_end).to_a * section_size).sort.zip((column_start..column_end).to_a * section_size)
      end
      
      def solve #:nodoc:
        sorted_sections = sections.sort { |a, b| values(b).nitems <=> values(a).nitems }
        failing_values = Array.new(puzzle.size, nil)
        missing_values = sorted_sections.collect { |section| options[:values].reject { |value| values(section).include?(value) } }
        entries = []
        section_index = 0
        until section_index == puzzle.size
          section = sorted_sections[section_index]
          if failing_values[section_index] == missing_values[section_index][0]
            raise ArgumentError.new('Invalid puzzle - cannot be solved') if entries.empty?
            entry = entries.pop
            self[*entry[:coord]] = nil
            missing_values[entry[:section_index]] << entry[:value]
            failing_values[entry[:section_index]] = entry[:failing_value] || entry[:value]
            unless section_index == entry[:section_index]
              failing_values[section_index] = nil
              section_index = entry[:section_index]
            end
          else
            until valid_section?(section)
              value = missing_values[section_index].shift
              section_values = values(section)
              coord = section[section_values.index(nil)]
              self[*coord] = value
              if valid_row?(coord[0]) && valid_column?(coord[1])
                entries << { :section_index => section_index, :coord => coord, :value => value, :failing_value => failing_values[section_index] }
                failing_values[section_index] = nil
              else
                self[*coord] = nil
                missing_values[section_index] << value
                failing_values[section_index] ||= value
                break
              end
            end
            section_index += 1 if missing_values[section_index].empty?
          end
        end
      end
      
      def validate_arguments! #:nodoc:
        raise ArgumentError.new('Puzzle size must be a square - e.g. 4x4, 9x9, 16x16, 25x25') unless section_size == Math.sqrt(puzzle.size) && puzzle.size == columns.size
        raise ArgumentError.new("Must specify #{puzzle.size} values for a #{puzzle.size}x#{puzzle.size} puzzle") unless puzzle.size == options[:values].size
        raise ArgumentError.new('Must specify unique values in options[:values]') unless options[:values] == options[:values].uniq
      end
      
  end
end