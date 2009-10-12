require 'test_helper'

class SudokuTest < Test::Unit::TestCase
  should 'solve puzzles of various sizes' do
    Sudoku::Puzzles.each do |puzzle|
      sudoku = Sudoku::Puzzle.new(puzzle)
      assert !sudoku.valid?
      sudoku.solve!
      assert sudoku.valid?
    end
  end
  
  should 'set the default options[:values] to a range up to the size of the puzzle' do
    Sudoku::Puzzles.each do |puzzle|
      assert_equal((1..puzzle.size).to_a.collect!{ |value| value.to_s }, Sudoku::Puzzle.new(puzzle).options[:values])
    end
  end
  
  context 'ArgumentError' do
    should 'be raised if the puzzle size is not a square' do
      assert_raises ArgumentError do
        Sudoku::Puzzle.new([[1,2], [3,4], [5,6]])
      end
      assert_raises ArgumentError do
        Sudoku::Puzzle.new(Array.new(10, Array.new(10)))
      end
    end
    
    should 'be raised if the size of options[:values] does not equal the puzzle size' do
      Sudoku::Puzzles.each do |puzzle|
        assert_raises ArgumentError do
          Sudoku::Puzzle.new(puzzle, :values => (1..(puzzle.size - 1)).to_a)
        end
        assert_raises ArgumentError do
          Sudoku::Puzzle.new(puzzle, :values => (1..(puzzle.size + 1)).to_a)
        end
      end
    end
    
    should 'be raised if options[:values] is not unique' do
      assert_raises ArgumentError do
        Sudoku::Puzzle.new(Sudoku::Puzzles.first, :values => Array.new(Sudoku::Puzzles.first.size, '1'))
      end
    end
    
    should 'be raised if the puzzle is invalid and cannot be solved' do
      Sudoku::InvalidPuzzles.each do |puzzle|
        assert_raises ArgumentError do
          Sudoku::Puzzle.new(puzzle).solve!
        end
      end
    end
  end
end