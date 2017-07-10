


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

def board_empty?(brd)
  brd.keys.all? { |num| brd[num] == INITIAL_MARKER }
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
  brd.each_with_object({}) { |(key, value), new_board| new_board[key] = value }
end

def get_score(brd, depth)
  return depth - 10 unless detect_winner(brd).nil?
  0
end

$choice = nil
$moves = []
$scores = []
# X's turn original
def computer_AI(brd, player, depth)
  $choice = brd.keys.first and return if board_empty?(brd)
  return depth - 10 if detect_winner(brd)
  return 0 if board_full?(brd)
  
  max = -10
  depth += 1
  scores = []
  moves = []

  empty_squares(brd).each do |square|
    new_brd = copy_board(brd)
    marker = get_player_marker(player)
    new_brd[square] = marker
    opposite_player = get_opposite_player(player)
    scores << -1*computer_AI(new_brd, opposite_player, depth)
    moves << square
  end
    
    if scores.max > max
      max = scores.max
      max_score_index = 0
      scores.each_with_index do |score, i|
        if scores[i] == max
          max_score_index = i
          break
        end
      end
    end
    $choice = moves[max_score_index]
    $moves = moves
    $scores = scores
    return max
end

brd = {1=>"O", 2=>"X", 3=>" ", 4=>" ", 5=>"X", 6=>" ", 7=>" ", 8=>" ", 9=>" "}
player = 'Computer'
computer_AI(brd, player, 0)
p $choice
p $moves
p $scores
