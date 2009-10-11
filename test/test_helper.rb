require 'rubygems'
require 'test/unit'
require 'shoulda'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'sudoku'

Sudoku::Puzzles = [
  [
    [nil,   9, nil,   6, nil,   8, nil,   1,   7],
    [nil,   5, nil,   9, nil,   1,   4, nil, nil],
    [  6, nil,   1, nil, nil, nil, nil, nil,   3],
    [nil,   8, nil, nil, nil,   4, nil, nil,   1],
    [nil, nil,   7,   8, nil,   2,   6, nil, nil],
    [  4, nil, nil,   7, nil, nil, nil,   2, nil],
    [  9, nil, nil, nil, nil, nil,   7, nil,   4],
    [nil, nil,   2,   3, nil,   9, nil,   8, nil],
    [  8,   4, nil,   1, nil,   7, nil,   3, nil]
  ],

  [
    [  2, nil, nil, nil, nil,   1, nil,   3,   8],
    [nil, nil, nil, nil, nil, nil, nil, nil,   5],
    [nil,   7, nil, nil, nil,   6, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil,   1,   3],
    [nil,   9,   8,   1, nil, nil,   2,   5,   7],
    [  3,   1, nil, nil, nil, nil,   8, nil, nil],
    [  9, nil, nil,   8, nil, nil, nil,   2, nil],
    [nil,   5, nil, nil,   6,   9,   7,   8,   4],
    [  4, nil, nil,   2,   5, nil, nil, nil, nil]
  ]
]

class Test::Unit::TestCase
end