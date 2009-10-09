require 'test_helper'

class SudokuTest < Test::Unit::TestCase
  should "probably rename this file and start testing for real" do
    board = [
      [2,   nil, nil, nil, nil, 1,   nil, 3,   8],
      [nil, nil, nil, nil, nil, nil, nil, nil, 5],
      [nil, 7,   nil, nil, nil, 6,   nil, nil, nil],
      [nil, nil, nil, nil, nil, nil, nil, 1,   3],
      [nil, 9,   8,   1,   nil, nil, 2,   5,   7],
      [3,   1,   nil, nil, nil, nil, 8,   nil, nil],
      [9,   nil, nil, 8,   nil, nil, nil, 2,   nil],
      [nil, 5,   nil, nil, 6,   9,   7,   8,   4],
      [4,   nil, nil, 2,   5,   nil, nil, nil, nil]
    ]
    
    sudoku = Sudoku.new(board)
    puts sudoku
    puts ''
    puts sudoku.solve
  end
end