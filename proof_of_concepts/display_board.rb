SQUARE_WIDTH = 5
SQUARE_HEIGHT = 3

def create_board(board_size)
  num_pipes = SQUARE_HEIGHT*board_size
  num_spacers = board_size - 1
  num_rows = num_pipes + num_spacers
  board_arr = []
  
  board_arr = []
  
  (1..num_rows).each do |row|
    if row % (SQUARE_HEIGHT + 1) == 0
      board_arr << ("-"*SQUARE_WIDTH + "+")*(board_size - 1) + "-"*SQUARE_WIDTH
    else
      board_arr << (" "*SQUARE_WIDTH + "|")*(board_size - 1) + " "*SQUARE_WIDTH
    end
  end
board_arr
end

def update_board(board, row, col, token)
  num_row_spacers = row - 1
  num_full_rows = SQUARE_HEIGHT*(row - 1)
  partial_row = (SQUARE_HEIGHT/2.0).ceil
  row_index = num_full_rows + partial_row + num_row_spacers - 1
  
  num_col_spacers = col - 1
  num_full_cols = SQUARE_WIDTH*(col - 1)
  partial_col = (SQUARE_WIDTH/2.0).ceil
  col_index = num_full_cols + partial_col + num_col_spacers  - 1
  
  board[row_index][col_index] = token
end


board = create_board(3)
puts board
update_board(board, 1, 1, 'X')
puts "\n\n"
puts board