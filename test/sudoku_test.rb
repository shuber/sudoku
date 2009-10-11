require 'test_helper'

class SudokuTest < Test::Unit::TestCase
  should "probably rename this file and start testing for real" do
    sudoku = Sudoku::Puzzle.new(Sudoku::Puzzles.first)
    puts sudoku.to_s
    puts ''
    puts sudoku.solve!.to_s
  end
end