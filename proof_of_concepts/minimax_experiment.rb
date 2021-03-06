require 'pry'

WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # cols
                [[1, 5, 9], [3, 5, 7]]              # diagonals
INITIAL_MARKER = ' '.freeze
PLAYER_MARKER = 'X'.freeze
COMPUTER_MARKER = 'O'.freeze
FIRST = 'choose'.freeze
INFINITY = 1.0 / 0

def display_cell(cell, num)
  if cell == ' '
    return num
  else
    return cell
  end
end

# rubocop:disable Metrics/AbcSize
def display_board(brd)
  system 'clear'
  puts "You're a #{PLAYER_MARKER}. Computer is a #{COMPUTER_MARKER}"
  puts ""
  puts "     |     |"
  puts "  #{display_cell(brd[1], 1)}  |  #{display_cell(brd[2], 2)}  |  #{display_cell(brd[3], 3)}"
  puts "     |     |"
  puts "-----+-----+-----"
  puts "     |     |"
  puts "  #{display_cell(brd[4], 4)}  |  #{display_cell(brd[5], 5)}  |  #{display_cell(brd[6], 6)}"
  puts "     |     |"
  puts "-----+-----+-----"
  puts "     |     |"
  puts "  #{display_cell(brd[7], 7)}  |  #{display_cell(brd[8], 8)}  |  #{display_cell(brd[9], 9)}"
  puts "     |     |"
  puts ""
end
# rubocop:enable Metrics/AbcSize

def joinor(arr, delimiter=', ', word='or')
  case arr.size
  when 0 then ''
  when 1 then arr.first
  when 2 then arr.join(" #{word} ")
  else
    arr[-1] = "#{word} #{arr.last}" # -1 index = last elm
    arr.join(delimiter)
  end
end

def initialize_board
  new_board = {}
  (1..9).each { |num| new_board[num] = INITIAL_MARKER }
  new_board
end

def prompt(msg)
  puts "=> #{msg}"
end

def empty_squares(brd)
  brd.keys.select { |num| brd[num] == INITIAL_MARKER }
end

def player_places_piece!(brd)
  square = ''
  loop do
    prompt "Choose a square: (#{joinor(empty_squares(brd))})"
    square = gets.chomp.to_i
    if empty_squares(brd).include?(square)
      break
    else
      prompt "Sorry, that's not a valid choice"
    end
  end

  brd[square] = PLAYER_MARKER
end

def board_full?(brd)
  empty_squares(brd).empty?
end

def somebody_won?(brd)
  !!detect_winner(brd)
end

def display_wins(player_wins, computer_wins)
  prompt "Player wins: #{player_wins}, Computer wins: #{computer_wins}"
end

def detect_winner(brd)
  WINNING_LINES.each do |line|
    if brd.values_at(*line).count(PLAYER_MARKER) == 3
      return 'player'
    elsif brd.values_at(*line).count(COMPUTER_MARKER) == 3
      return 'computer'
    end
  end

  nil
end

def evaluate(brd)
  winner = detect_winner(brd)
  if winner == 'computer'
    return 10
  elsif winner == 'player'
    return -10
  else
    return 0
  end
end

def get_available_moves(board)
  moves = []
  board.values.each do |v|
    moves.push(v) if v == INITIAL_MARKER
  end
  moves
end

def minimax(brd, depth, current_player)

  score = evaluate(brd)
 
  # If Computer has won, return score
  return score if score == 10

  # If player has won, return score
  return score if score == -10

  # NO more moves and no winners, so tie
  return 0 if board_full?(brd)

  # maximizer's move
  if current_player == 'computer'
    best = -INFINITY
    # Play each spot that is empty
    brd.each do |cell, status|
      if status == INITIAL_MARKER
        brd[cell] = COMPUTER_MARKER 
        # Call minimax recursively and find the max value
        best = [best, minimax(brd, depth + 1, 'player')].max
        # undo the move
        brd[cell] = INITIAL_MARKER
      end
    end
    return best
  # minimizer's move
  elsif current_player == 'player'
    best = INFINITY
    # Play each spot that is empty
    brd.each do |cell, status|
      if status == INITIAL_MARKER
        brd[cell] = PLAYER_MARKER 
        # Call minimax recursively and find the max value
        best = [best, minimax(brd, depth + 1, 'computer')].min
        # undo the move
        brd[cell] = INITIAL_MARKER
      end
    end
    return best
  end
end

# For each possible move, run minimax on that path to find best move
def find_best_move(brd)

  # Shortcircuit first move so 5 is always choosen
  return 5 if empty_squares(brd).count == 9


  best_val = -INFINITY
  best_move = nil

  brd.each do |cell, status|
    if status == INITIAL_MARKER
      brd[cell] = COMPUTER_MARKER
      move_val = minimax(brd, 0, 'player')
      brd[cell] = INITIAL_MARKER
      if move_val > best_val
        best_val = move_val
        best_move = cell
      end
    end
  end
  return best_move
end

def who_goes_first?
  answer = '' 
  if FIRST == 'choose'
    prompt "Shall the player or the computer go first?"
    answer = gets.chomp
    while answer != "player" && answer != "computer"
      puts "Sorry, please enter player or computer"
      answer = gets.chomp
    end
  elsif FIRST == 'player'
    answer = 'player'
  else
    answer = 'computer'
  end
  answer
end

def play_piece!(board, current_player)
  if current_player == 'player'
    player_places_piece!(board)
  else
    computer_move = find_best_move(board)
    board[computer_move] = COMPUTER_MARKER
  end
end

def alternate_player(current_player)
  if current_player == 'player'
    current_player = 'computer'
  else
    current_player = 'player'
  end
end


if __FILE__ == $PROGRAM_NAME

  player_wins = 0
  computer_wins = 0
  
  while player_wins < 5 && computer_wins < 5
    board = initialize_board
    first = who_goes_first?
    current_player = first
  
    loop do
      display_board(board)
      display_wins(player_wins, computer_wins)
      play_piece!(board, current_player)
      break if somebody_won?(board) || board_full?(board)
      current_player = alternate_player(current_player)
    end
  
    display_board(board)
  
    winner = detect_winner(board)
    if winner 
      winner == 'Player' ? player_wins += 1 : computer_wins += 1
      prompt "#{winner} won!"
    else
      prompt "It's a tie!"
    end
  
    prompt "Would you like to play again? (y or n)"
    play_again = gets.chomp.downcase
    break unless play_again.start_with?('y')
  
  end
  
  prompt "Thanks for playing Tic Tac Toe. Goodbye!"
end

#############################################

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
  return depth - 10 if someone_won?(brd)
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

    max_score_index = scores.each_with_index.max[1]
    $choice = moves[max_score_index]
    $moves = moves
    $scores = scores
    return scores[max_score_index]
end


brd = {1=>" ", 2=>" ", 3=>" ", 4=>" ", 5=>" ", 6=>" ", 7=>" ", 8=>" ", 9=>" "}
player = 'Player'
computer_AI(brd, player, 0)
p $choice
p $moves
p $scores
