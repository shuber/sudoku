require 'enumerator'
Dir[File.join(File.dirname(__FILE__), 'sudoku', '**', '*.rb')].each { |file| require file }