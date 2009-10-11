class Sudoku
  class Board < Array
    
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
    
    def section(row_offset, column_offset)
      row_start = row_offset * section_size
      row_end = row_start + section_size - 1
      column_start = column_offset * section_size
      column_end = column_start + section_size - 1
      coordinates = ((row_start..row_end).to_a * section_size).sort.zip((column_start..column_end).to_a * section_size)
      coordinates.inject([]) { |array, (row, column)| array << self[row][column] }
    end
    
    def section_size
      @section_size ||= Math.sqrt(size).to_i
    end
    
    def sections
      (1..section_size).inject([]) do |array, row_offset|
        (1..section_size).inject(array) do |array, column_offset|
          array << section(row_offset - 1, column_offset - 1)
        end
      end
    end
    
    def to_s
      inject([]) { |rows, row| rows << row.map { |value| (value || options[:blank]).to_s.rjust(max_value_size) }.join(' ') }.join("\n")
    end
    
    def valid?
      all? { |row| valid_row?(row) } && columns.all? { |column| valid_column?(column) } && sections.all? { |section| valid_section?(section) }
    end
    
    protected
    
      def validate_arguments!
        raise ArgumentError.new('Board size must be a square - e.g. 4x4, 9x9, 16x16, 25x25') unless section_size == Math.sqrt(size) && size == columns.size
        raise ArgumentError.new("Must specify #{size} values for a #{size}x#{size} board") unless size == options[:values].size
        raise ArgumentError.new('Must specify unique values in options[:values]') unless options[:values] == options[:values].uniq
      end
      
      def valid_column?(column)
        column == column.compact.uniq!
      end
      
      def valid_row?(row)
        row == row.compact.uniq!
      end
      
      def valid_section?(section)
        section.sort == options[:values].sort
      end
      
  end
end

board = [
  [2,   nil, nil, nil, nil, 1,   nil, 3,   8  ],
  [nil, nil, nil, nil, nil, nil, nil, nil, 5  ],
  [nil, 7,   nil, nil, nil, 6,   nil, nil, nil],
  [nil, nil, nil, nil, nil, nil, nil, 1,   3  ],
  [nil, 9,   8,   1,   nil, nil, 2,   5,   7  ],
  [3,   1,   nil, nil, nil, nil, 8,   nil, nil],
  [9,   nil, nil, 8,   nil, nil, nil, 2,   nil],
  [nil, 5,   nil, nil, 6,   9,   7,   8,   4  ],
  [4,   nil, nil, 2,   5,   nil, nil, nil, nil]
]

b = Sudoku::Board.new(board)
puts b.sections.inspect