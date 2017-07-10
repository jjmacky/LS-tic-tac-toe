WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # cols
                [[1, 5, 9], [3, 5, 7]]   

INITIAL_MARKER = ' '
PLAYER_MARKER = 'X'
COMPUTER_MARKER = 'O'

def board_full?(brd)
  empty_squares(brd).empty?
end

def empty_squares(brd)
  brd.keys.select { |num| brd[num] == INITIAL_MARKER }
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

def get_player_marker(player)
  player == 'Player' ? 'X' : 'O'
end

def get_opposite_player(player)
  player == 'Player' ? 'Computer' : 'Player'
end

def copy_board(brd)
  new_board = {}
  brd.each { |key, value| new_board[key] = value }
  new_board
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
    new_brd = copy_board(brd)
    marker = get_player_marker(player)
    new_brd[square] = marker
    opposite_player = get_opposite_player(player)
    scores << computer_AI(new_brd, opposite_player, depth)
    moves << square
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

# could update using minimax
#arr = [5, 4, -234, 345, 7,-3, 5, -297, 337]
#p arr.each_with_index.minmax => [[-297, 7], [345, 3]]


brd = {1=>"X", 2=>"O", 3=>" ", 4=>" ", 5=>"O", 6=>" ", 7=>"X", 8=>" ", 9=>" "}
player = 'Player'
computer_AI(brd, player, 0)
p $choice
p $moves
p $scores
