require 'matrix'
SQUARE_WIDTH = 5
SQUARE_HEIGHT = 3

class SetableMatrix < Matrix
  public :"[]=", :set_element, :set_component
end

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

def place_piece(visual_board, row, col, player_marker)
  num_row_spacers = row
  num_full_rows = SQUARE_HEIGHT*row
  partial_row = (SQUARE_HEIGHT/2.0).ceil
  row_index = num_full_rows + partial_row + num_row_spacers - 1
  
  num_col_spacers = col
  num_full_cols = SQUARE_WIDTH*col
  partial_col = (SQUARE_WIDTH/2.0).ceil
  col_index = num_full_cols + partial_col + num_col_spacers - 1
  
  visual_board[row_index][col_index] = player_marker
end

def generate_board(board_size)
  SetableMatrix.rows([*(1..board_size**2)].each_slice(board_size).to_a)
end

def print_board(board)
  visual_board = create_visual_board(board.row_count)
  max_row_index = board.row_count - 1
  max_col_index = board.column_count - 1
  
  0.upto(max_row_index).each do |i|
    0.upto(max_col_index).each do |j|
      element = board.element(i, j)
      if element.is_a? String
        place_piece(visual_board, i, j, element)
      end
    end
  end
  puts visual_board
end

board_size = 5
board = generate_board(board_size)
board[4, 2] = "X"
board[0, 2] = "O"
print_board(board)