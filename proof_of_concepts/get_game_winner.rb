
require 'matrix'

def generate_board(board_size)
  SetableMatrix.rows([*(1..board_size**2)].each_slice(board_size).to_a)
end

class SetableMatrix < Matrix
  public :"[]=", :set_element, :set_component
end

def get_winning_lines(board)
  n = board.row_size
  winning_lines = 0.upto(n-1).each_with_object([]) do |i, arr| 
                    arr << board.row(i).to_a
                    arr << board.column(i).to_a
                  end
  winning_lines << 0.upto(n-1).collect { |i| board.element(i, i) }
  winning_lines << 0.upto(n-1).collect { |i| board.element(i, (n-1)-i) }  
  winning_lines
end

def translate_winning_lines(winning_lines, board)
  winning_lines.map do |line|
    line.map { |square| board.index(square) }
  end
end

def get_winner(winning_lines, board, markers)
  winner = nil
  winning_lines.each do |line|
     line_result = line.map { |loc| board.element(*loc) }
    if line_result.all? { |i| line_result.first == i }
      winner = markers[line_result.first]
      break
    end
  end
  winner 
end

def winner?(winning_lines, board, markers)
  !!get_winner(winning_lines, board, markers)
end

def board_full?(board)
  board.all? { |square| square.is_a? String }
end

def game_over?(winning_lines, board, markers)
  winner?(winning_lines, board, markers) || board_full?(board)
end

markers = {"X" => "James", "O" => "Brad"}
board_size = 5
board = generate_board(board_size)
board[0, 0] = "X"
board[0, 1] = "X"
board[0, 2] = "O"
board[0, 3] = "X"
board[0, 4] = "X"
winning_lines = translate_winning_lines(get_winning_lines(board), board)
p get_winner(winning_lines, board, markers)
p board
p winner?(winning_lines, board, markers)


board = SetableMatrix[['a', 'b'],['g', 'f']]
p board_full?(board)