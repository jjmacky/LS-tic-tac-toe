SQUARE_WIDTH = 5
SQUARE_HEIGHT = 3
PLAYER_TYPES = ['human', 'computer']
MIN_BOARD_SIZE = 2
MAX_BOARD_SIZE = 13
COMPUTER_MARKERS = ['X', 'O', '*', '+', '$', '#']
SLEEP_TIME = 0.1

def prompt(message)
  puts "=> #{message}"
end

def winner?(board, players)
  !!get_winner(board, players)
end

def create_board
  board_size = ''
  loop do
    prompt("Please enter the width of the board in squares:")
    board_size = gets.chomp
    break if valid_board_size?(board_size)
    prompt("Invalid board width.")
  end
  board_size = board_size.to_i
  Array.new(board_size) { Array.new(board_size) }
end

def row_winner?(board, marker)
  board.any? do |row|
    row.all? { |i| i == marker }
  end
end

def column_winner?(board, marker)
  0.upto(board.size - 1).any? do |col|
    0.upto(board.size - 1).all? do |row|
      board[row][col] == marker
    end
  end
end

def diag_winner?(board, marker)
  left_to_right =
    0.upto(board.size - 1).all? do |i|
      board[i][i] == marker
    end

  right_to_left =
    0.upto(board.size - 1).all? do |i|
      board[i][(board.size - 1) - i] == marker
    end

  left_to_right || right_to_left
end

def get_winner(board, players)
  winner =
    players.each_key.select do |player|
      marker = players[player][:marker]
      row_winner?(board, marker) ||
        column_winner?(board, marker) ||
        diag_winner?(board, marker)
    end
  winner.first
end

def calculate_num_rows(board)
  board_size = board.size
  num_pipes = SQUARE_HEIGHT * board_size
  num_spacers = board_size - 1
  num_pipes + num_spacers
end

def create_spacer_row(board)
  ("-" * SQUARE_WIDTH + "+") *
    (board.size - 1) + "-" * SQUARE_WIDTH
end

def create_standard_row(board)
  (" " * SQUARE_WIDTH + "|") *
    (board.size - 1) + " " * SQUARE_WIDTH
end

def create_visual_board(board)
  num_rows = calculate_num_rows(board)
  board_arr = []

  (1..num_rows).each do |row|
    spacer_row = row % (SQUARE_HEIGHT + 1) == 0
    board_arr << if spacer_row
                   create_spacer_row(board)
                 else
                   create_standard_row(board)
                 end
  end
  board_arr
end

def print_visual_board(board)
  visual_board = create_visual_board(board)
  max_row_index = board.size - 1
  max_col_index = board.size - 1

  0.upto(max_row_index).each do |row|
    0.upto(max_col_index).each do |col|
      element = board[row][col]
      unless element.nil?
        place_visual_piece(visual_board, row, col, element)
      end
    end
  end
  puts visual_board
end

def place_visual_piece(visual_board, row, col, marker)
  num_row_spacers = row
  num_full_rows = SQUARE_HEIGHT * row
  partial_row = (SQUARE_HEIGHT / 2.0).ceil
  row_index = num_full_rows + partial_row + num_row_spacers - 1

  num_col_spacers = col
  num_full_cols = SQUARE_WIDTH * col
  partial_col = (SQUARE_WIDTH / 2.0).ceil
  col_index = num_full_cols + partial_col + num_col_spacers - 1

  visual_board[row_index][col_index] = marker
end

def int?(number)
  number == number.to_i.to_s
end

def valid_row?(board, row)
  row.to_i <= board.size
end

def valid_col?(board, col)
  col.to_i <= board.size
end

def valid_square?(board, row, col)
  int?(row) &&
    int?(col) &&
    valid_row?(board, row) &&
    valid_col?(board, col)
end

def empty_square?(board, row, col)
  board[row][col].nil?
end

def board_full?(board)
  return true unless board.flatten.any?(&:nil?)
  false
end

def place_piece(board, row, col, marker)
  board[row][col] = marker
end

def valid_num_players?(board, num_players)
  max_num_players = (board.size / 2.0).ceil
  int?(num_players) &&
    num_players.to_i >= 1 &&
    num_players.to_i <= max_num_players
end

def empty_string?(string)
  string.split.all? { |s| s == ' ' }
end

def valid_marker?(marker, players)
  marker.length == 1 &&
    !empty_string?(marker) &&
    !get_player_markers(players).include?(marker)
end

def valid_name?(name, players)
  name.length >= 1 &&
    !empty_string?(name) &&
    !players.keys.include?(name)
end

def get_player_markers(players)
  players.values.map do |value|
    value[:marker]
  end
end

def valid_type?(type)
  int?(type) &&
    type.to_i >= 0 &&
    type.to_i <= PLAYER_TYPES.length - 1
end

def valid_board_size?(board_size)
  int?(board_size) &&
    board_size.to_i >= MIN_BOARD_SIZE &&
    board_size.to_i <= MAX_BOARD_SIZE
end

def get_computer_marker(players)
  taken_markers = []
  players.each_value do |value|
    taken_markers << value[:marker]
  end
  (COMPUTER_MARKERS - taken_markers).sample
end

def get_computer_name(player)
  "Computer #{player}"
end

def transpose(matrix)
  length = matrix.length
  matrix_transpose = Array.new(length) { [] }

  0.upto(length - 1).each do |i|
    0.upto(length - 1).each do |j|
      matrix_transpose[j][i] = matrix[i][j]
    end
  end
  matrix_transpose
end

def switch_entries(matrix)
  matrix.map do |square|
    [square.last, square.first]
  end
end

def get_empty_squares(board)
  empty_squares = []
  board.each_with_index do |row, i|
    row.each_with_index do |col, j|
      empty_squares << [i, j] if col.nil?
    end
  end
  empty_squares
end

def row_ai(board, markers, squares_from_victory)
  threashold = board.size - squares_from_victory
  markers.each_with_object([]) do |marker, squares|
    board.each_with_index do |row, i|
      if row.count(marker) >= threashold
        row.each_with_index do |col, j|
          squares << [i, j] if col.nil?
        end
      end
    end
  end
end

def col_ai(board, markers, squares_from_victory)
  switch_entries(row_ai(transpose(board), markers, squares_from_victory))
end

def get_left_to_right(board)
  0.upto(board.size - 1).each_with_object({}) do |i, hash|
    hash[[i, i]] = board[i][i]
  end
end

def get_right_to_left(board)
  board_size = board.size
  0.upto(board_size - 1).each_with_object({}) do |i, hash|
    hash[[i, board_size - 1 - i]] = board[i][(board_size - 1) - i]
  end
end

def extract_diag(board_hash, markers, squares_from_victory)
  threashold = board_hash.size - squares_from_victory
  empty_squares = []
  markers.each do |marker|
    count = board_hash.values.count(marker)
    if count >= threashold
      empty_squares +=
        board_hash.each_with_object([]) { |(k, v), a| a << k if v.nil? }
    end
  end
  empty_squares
end

def diag_ai(board, markers, squares_from_victory)
  result = []
  left_to_right = get_left_to_right(board)
  empty_squares = extract_diag(left_to_right, markers, squares_from_victory)
  result += empty_squares unless empty_squares.empty?

  right_to_left = get_right_to_left(board)
  empty_squares = extract_diag(right_to_left, markers, squares_from_victory)
  result += empty_squares unless empty_squares.empty?
  result
end

def defensive_ai(board, markers)
  1.upto(2).each do |squares_from_victory|
    defensive_moves = []
    row_moves = row_ai(board, markers, squares_from_victory)
    defensive_moves += row_moves unless row_moves.empty?
    col_moves = col_ai(board, markers, squares_from_victory)
    defensive_moves += col_moves unless col_moves.empty?
    diag_moves = diag_ai(board, markers, squares_from_victory)
    defensive_moves += diag_moves unless diag_moves.empty?
    return defensive_moves.sample unless defensive_moves.empty?
  end
  nil
end

def offensive_ai(board, markers)
  squares_from_victory = 1
  offensive_moves = []
  row_moves = row_ai(board, markers, squares_from_victory)
  offensive_moves += row_moves unless row_moves.empty?
  col_moves = col_ai(board, markers, squares_from_victory)
  offensive_moves += col_moves unless col_moves.empty?
  diag_moves = diag_ai(board, markers, squares_from_victory)
  offensive_moves += diag_moves unless diag_moves.empty?
  return offensive_moves.sample unless offensive_moves.empty?
  nil
end

def computer_ai(board, other_markers, player_marker)
  offensive_move = offensive_ai(board, player_marker)
  return offensive_move unless offensive_move.nil?
  defensive_move = defensive_ai(board, other_markers)
  return defensive_move unless defensive_move.nil?
  get_empty_squares(board).sample
end

def create_diag_board(visual_board, row, col, player_marker)
  until row <= col
    place_visual_piece(visual_board, row, col, player_marker)
    place_visual_piece(visual_board, col, row, player_marker)
    row -= 1
    col += 1
  end
  place_visual_piece(visual_board, row, col, player_marker) if row == col
  visual_board
end

def diagonal_board_flourish(board, player_marker)
  board_size = board.size
  max_index = board_size - 1
  square_counter = [*(0..max_index)] + [*(1..max_index)]

  square_counter.each_with_index do |diag_counter, index|
    visual_board = create_visual_board(board)
    row = index <= max_index ? diag_counter : max_index
    col = index <= max_index ? 0 : diag_counter
    visual_board = create_diag_board(visual_board, row, col, player_marker)

    system 'clear'
    puts visual_board
    sleep SLEEP_TIME
  end
end

def lets_play_message
  system 'clear'
  3.times do
    puts "Let's play!"
    sleep(0.5)
    system 'clear'
    puts ""
    sleep(0.5)
    system 'clear'
  end
end

def game_intro(board, players)
  lets_play_message

  players.each_value do |value|
    player_marker = value[:marker]
    diagonal_board_flourish(board, player_marker)
  end
end

def num_players(board)
  num_players = ''
  loop do
    prompt("Please enter the number of players:")
    num_players = gets.chomp
    break if valid_num_players?(board, num_players)
    prompt("Invalid number of players. Try again.")
  end
  num_players.to_i
end

def player_type
  type = ''
  loop do
    prompt("What kind of player is this?")
    prompt("Enter 0 for human, 1 for computer.")
    type = gets.chomp
    break if valid_type?(type)
    prompt("Invalid player type.")
  end
  type
end

def player_name(players, player, type)
  if type == 'computer'
    player_name = get_computer_name(player)
  else
    player_name = ''
    loop do
      prompt("Player #{player} please enter a name:")
      player_name = gets.chomp
      break if valid_name?(player_name, players)
      prompt("Invalid name, please reenter.")
    end
  end
  player_name
end

def player_marker(players, type)
  if type == 'computer'
    marker = get_computer_marker(players)
  else
    marker = ''
    loop do
      prompt("Enter a marker:")
      marker = gets.chomp
      break if valid_marker?(marker, players)
      prompt("Invalid name, please reenter.")
    end
  end
  marker
end

def collect_player_info(num_players)
  players = {}
  1.upto(num_players).each do |player|
    prompt("Let's get some player info!")
    type = PLAYER_TYPES[player_type.to_i]
    player_name = player_name(players, player, type)
    marker = player_marker(players, type)

    players[player_name] = {}
    players[player_name][:marker] = marker
    players[player_name][:type] = type
  end
  players
end

def user_selection(board, player)
  prompt("#{player} it's your turn.")
  row = ''
  col = ''
  loop do
    prompt("Enter row:")
    row = gets.chomp
    prompt("Enter col:")
    col = gets.chomp
    if  valid_square?(board, row, col) &&
        empty_square?(board, row.to_i - 1, col.to_i - 1)
      break
    end
    prompt("Sorry, choose another square.")
  end
  [row.to_i - 1, col.to_i - 1]
end

loop do
  board = create_board
  num_players = num_players(board)
  players = collect_player_info(num_players)
  game_intro(board, players)
  system 'clear'
  print_visual_board(board)

  loop do
    players.each_pair do |player, value|
      if value[:type] == 'human'
        row, col = user_selection(board, player)
        place_piece(board, row, col, value[:marker])

      else
        player_marker = [value[:marker]]
        other_markers = get_player_markers(players) - player_marker
        row, col = computer_ai(board, other_markers, player_marker)
        place_piece(board, row, col, value[:marker])
      end

      system 'clear'
      print_visual_board(board)
      break if winner?(board, players) || board_full?(board)
    end
    break if winner?(board, players) || board_full?(board)
  end

  winner = get_winner(board, players)
  prompt winner.nil? ? "It's a tie!" : "#{winner} is the winner!"

  play_again = ''
  loop do
    prompt("Would you like to play again (y/n)?")
    play_again = gets.chomp.downcase
    break if play_again == 'y' || play_again == 'n'
    prompt("Sorry, invalid response.")
  end
  break unless play_again == 'y'
end
prompt("Thanks for playing!")
