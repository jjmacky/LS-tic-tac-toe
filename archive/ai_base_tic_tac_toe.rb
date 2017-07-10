WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # cols
                [[1, 5, 9], [3, 5, 7]]              # diagnals

INITIAL_MARKER = ' '
PLAYER_MARKER = 'X'
COMPUTER_MARKER = 'O'

def prompt(msg)
  puts "=> #{msg}"
end

# rubocop: disable Metrics/AbcSize
def display_board(brd)
  system 'clear'
  puts "You're a #{PLAYER_MARKER}. Computer is #{COMPUTER_MARKER}."
  puts ""
  puts "     |     |     "
  puts "  #{brd[1]}  |  #{brd[2]}  |  #{brd[3]}  "
  puts "     |     |     "
  puts "-----+-----+-----"
  puts "     |     |     "
  puts "  #{brd[4]}  |  #{brd[5]}  |  #{brd[6]}  "
  puts "     |     |     "
  puts "-----+-----+-----"
  puts "     |     |     "
  puts "  #{brd[7]}  |  #{brd[8]}  |  #{brd[9]}  "
  puts "     |     |     "
  puts ""
end
# rubocop: enable Metrics/AbcSize

def intialize_board
  new_board = {}
  (1..9).each { |num| new_board[num] = INITIAL_MARKER }
  new_board
end

def empty_squares(brd)
  brd.keys.select { |num| brd[num] == INITIAL_MARKER }
end

def player_places_piece!(brd)
  square = ''
  loop do
    prompt "Choose a square #{empty_squares(brd).join(', ')}:"
    square = gets.chomp.to_i
    break if empty_squares(brd).include?(square)
    prompt "Sorry, that's not a valid choice."
  end

  brd[square] = PLAYER_MARKER
end

def get_score(brd, depth)
  winner = detect_winner(brd)
  return 10 - depth if winner == 'Player'
  return depth - 10 if winner == 'Computer'
  0
end

$choice = ''
$moves = []
$scores = []
# X's turn original
def computer_AI(brd, player, depth)
  if board_full?(brd) || someone_won?(brd)
    return get_score(brd, depth)
  end
  
  depth += 1
  scores = []
  moves = []

  empty_squares(brd).each do |square|
    marker = get_player_marker(player)
    brd[square] = marker
    opposite_player = get_opposite_player(player)
    scores << computer_AI(brd, opposite_player, depth)
    moves << square
    brd[square] = INITIAL_MARKER
  end

  if player == 'Player'
    max_score_index = scores.each_with_index.max[1]
    $choice = moves[max_score_index]
    $moves = moves
    $scores = scores
    return scores[max_score_index]
  else
    min_score_index = scores.each_with_index.min[1]
    $choice = moves[min_score_index]
    $moves = moves
    $scores = scores
    return scores[min_score_index]
  end
end

def get_player_marker(player)
  player == 'Player' ? 'X' : 'O'
end

def get_opposite_player(player)
  player == 'Player' ? 'Computer' : 'Player'
end

def computer_places_piece!(brd)
  computer_AI(brd, 'Computer', 0)
  brd[$choice] = COMPUTER_MARKER
end

def board_full?(brd)
  empty_squares(brd).empty?
end

def someone_won?(brd)
  !!detect_winner(brd)
end

def detect_winner(brd)
  WINNING_LINES.each do |line|
    return 'Player' if brd.values_at(*line).count(PLAYER_MARKER) == 3
    return 'Computer' if brd.values_at(*line).count(COMPUTER_MARKER) == 3
  end
  nil
end

loop do
  board = intialize_board

  loop do
    display_board(board)

    player_places_piece!(board)
    break if someone_won?(board) || board_full?(board)

    computer_places_piece!(board)
    break if someone_won?(board) || board_full?(board)
  end

  display_board(board)

  if someone_won?(board)
    prompt "#{detect_winner(board)} won!"
  else
    prompt "It's a tie!"
  end

  prompt "Play again? (y or n)"
  answer = gets.chomp
  break unless answer.downcase.start_with?('y')
end

prompt "Thanks for playing Tic Tac Toe! Good bye!"
