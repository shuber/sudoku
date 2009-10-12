require 'test_helper'

class SudokuTest < Test::Unit::TestCase
  should "probably rename this file and start testing for real" do
    sudoku = Sudoku::Puzzle.new(Sudoku::Puzzles.first)
    puts sudoku.puzzle
    puts ''
    puts sudoku.solve!.puzzle
  end
end