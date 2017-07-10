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

# X's turn original
def computer_AI(brd, player)
  games = []
  
  if board_full?(brd) || someone_won?(brd)
    games << brd
    return games
  end
  
  empty_squares(brd).each do |square|
    new_brd = copy_board(brd)
    marker = get_player_marker(player)
    new_brd[square] = marker
    opposite_player = get_opposite_player(player)
    games << computer_AI(new_brd, opposite_player)
  end
  return games
end


brd = {1=>"O", 2=>"X", 3=>"X", 4=>"O", 5=>"O", 6=>" ", 7=>"X", 8=>" ", 9=>" "}
player = 'Player'
p computer_AI(brd, player)

