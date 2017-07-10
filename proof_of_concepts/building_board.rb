def create_board(board_size)
  Array.new(board_size) { Array.new(board_size) }
end

def row_winner(board, marker)
  board.any? do |row|
    row.all? { |i| i == marker } 
  end
end

def column_winner(board, marker)
  0.upto(board.size - 1).any? do |col|
    0.upto(board.size - 1).all? do |row|
      board[row][col] == marker
    end
  end
end

def diag_winner(board, marker)
  left_to_right =
  0.upto(board.size - 1).all? do |i|
    board[i][i] == marker
  end 
  
  right_to_left =
  0.upto(board.size - 1).all? do |i|
    board[i][(board.size - 1) - i] == marker
  end
  
  left_to_right or right_to_left
end


board_size = 5
marker = 'X'
board = create_board(board_size)
board[1][0] = 'X'
board[1][1] = 'X'
board[1][2] = 'X'
board[1][3] = 'X'
board[1][4] = 'O'
row_winner(board, marker)


board_size = 5
board = create_board(board_size)
board[0][1] = 'X'
board[1][1] = 'X'
board[2][1] = 'X'
board[3][1] = 'X'
board[4][1] = 'X'
column_winner(board, marker)


board_size = 5
board = create_board(board_size)
board[0][0] = 'X'
board[1][1] = 'X'
board[2][2] = 'X'
board[3][3] = 'X'
board[4][4] = 'X'
diag_winner(board, marker)
board[0][4] = 'X'
board[1][3] = 'X'
board[2][2] = 'X'
board[3][1] = 'X'
board[4][0] = 'X'
diag_winner(board, marker)
