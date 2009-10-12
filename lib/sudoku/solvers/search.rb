module Sudoku
  module Solvers
    module Search
      
      protected
      
        def solve #:nodoc:
          sorted_sections = sections.sort { |a, b| values(b).nitems <=> values(a).nitems }
          failing_values = Array.new(puzzle.size, nil)
          missing_values = sorted_sections.collect { |section| options[:values].reject { |value| values(section).include?(value) } }
          entries = []
          section_index = 0
          until section_index == puzzle.size
            section = sorted_sections[section_index]
            if failing_values[section_index] == missing_values[section_index][0]
              unsolvable_puzzle! if entries.empty?
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
                coord = section[section_values.index(nil)] rescue unsolvable_puzzle!
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
        
    end
  end
end