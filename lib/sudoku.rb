module Sudoku
  # Solves square Sudoku puzzles
  #
  # See http://en.wikipedia.org/wiki/Sudoku
  class Puzzle < Array
    
    alias_method :columns, :transpose
    
    def initialize(rows, options = {})
      super rows
      self.options.merge!(options)
      validate_arguments!
    end
    
    def column(index)
      columns[index]
    end
    
    def options
      @options ||= { :values => (1..size).to_a, :blank => '.' }
    end
    
    def max_value_size
      @max_value_size ||= options[:values].max { |a, b| a.size <=> b.size }
    end
    
    def row(index)
      self[index]
    end
    
    def section_size
      @section_size ||= Math.sqrt(size).to_i
    end
    
    def sections
      (1..section_size).inject([]) do |array, row_offset|
        (1..section_size).inject(array) do |array, column_offset|
          array << section_coordinates(row_offset - 1, column_offset - 1)
        end
      end
    end
    
    # Solves this instance's board, returns self
    def solve!
      solve
      self
    end
    
    # Returns a string representation of the board
    def to_s
      inject([]) { |rows, row| rows << row.map { |value| (value || options[:blank]).to_s.rjust(max_value_size) }.join(' ') }.join("\n")
    end
    
    def valid?
      1.upto(size) { |index| return false unless valid_row?(index - 1) && valid_column?(index - 1) }
      sections.all? { |section| valid_section?(section) }
    end
    
    def values(coords)
      coords.collect { |coord| self[coord[0]][coord[1]] }
    end
    
    protected
    
      def section_coordinates(row_offset, column_offset)
        row_start = row_offset * section_size
        row_end = row_start + section_size - 1
        column_start = column_offset * section_size
        column_end = column_start + section_size - 1
        ((row_start..row_end).to_a * section_size).sort.zip((column_start..column_end).to_a * section_size)
      end
      
      def solve
        sorted_sections = sections.sort { |a, b| values(a).nitems <=> values(b).nitems }.reverse!
        failing_values = Array.new(size, nil)
        missing_values = sorted_sections.collect { |section| options[:values].reject { |value| values(section).include?(value) } }
        entries = []
        section_index = 0
        until section_index == size
          section = sorted_sections[section_index]
          if failing_values[section_index] == missing_values[section_index][0]
            raise ArgumentError.new('Invalid puzzle - cannot be solved') if entries.empty?
            entry = entries.pop
            self[entry[:coord][0]][entry[:coord][1]] = nil
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
              self[coord[0]][coord[1]] = value
              if valid_row?(coord[0]) && valid_column?(coord[1])
                entries << { :section_index => section_index, :coord => coord, :value => value, :failing_value => failing_values[section_index] }
                failing_values[section_index] = nil
              else
                self[coord[0]][coord[1]] = nil
                missing_values[section_index] << value
                failing_values[section_index] ||= value
                break
              end
            end
            section_index += 1 if missing_values[section_index].empty?
          end
        end
      end
      
      def validate_arguments!
        raise ArgumentError.new('Puzzle size must be a square - e.g. 4x4, 9x9, 16x16, 25x25') unless section_size == Math.sqrt(size) && size == columns.size
        raise ArgumentError.new("Must specify #{size} values for a #{size}x#{size} puzzle") unless size == options[:values].size
        raise ArgumentError.new('Must specify unique values in options[:values]') unless options[:values] == options[:values].uniq
      end
      
      def valid_column?(index)
        column_values = column(index).compact
        column_values == column_values.uniq
      end
      
      def valid_row?(index)
        row_values = self[index].compact
        row_values == row_values.uniq
      end
      
      def valid_section?(section)
        values(section).compact.sort == options[:values].sort
      end
      
  end
end