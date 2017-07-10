SQUARE_WIDTH = 5
SQUARE_HEIGHT = 3

def create_visual_board(board_size)
  num_pipes = SQUARE_HEIGHT*board_size
  num_spacers = board_size - 1
  num_rows = num_pipes + num_spacers
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

def place_piece(visual_board, row, col, token)
  num_row_spacers = row
  num_full_rows = SQUARE_HEIGHT*row
  partial_row = (SQUARE_HEIGHT/2.0).ceil
  row_index = num_full_rows + partial_row + num_row_spacers - 1
  
  num_col_spacers = col
  num_full_cols = SQUARE_WIDTH*col
  partial_col = (SQUARE_WIDTH/2.0).ceil
  col_index = num_full_cols + partial_col + num_col_spacers - 1
  
  visual_board[row_index][col_index] = token
end

def diagonal_board_flourish(board_size, player_marker)
max_index = board_size - 1
square_counter = [*(0..max_index)] + [*(1..max_index)]
  square_counter.each_with_index do |diag_counter, index|
    visual_board = create_visual_board(board_size)
    row = index <= max_index ? diag_counter : max_index
    col = index <= max_index ? 0 : diag_counter
    until row <= col
      place_piece(visual_board, row, col, player_marker)
      place_piece(visual_board, col, row, player_marker)
      row -= 1; col += 1
    end
    place_piece(visual_board, row, col, player_marker) if row == col
    system 'clear'
    puts visual_board
    sleep (SLEEP_TIME)
  end
end

SLEEP_TIME = 0.08
board_size = 5
player_marker = 'X'
diagonal_board_flourish(board_size, player_marker)
player_marker = 'O'
diagonal_board_flourish(board_size, player_marker)

