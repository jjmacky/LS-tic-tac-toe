require 'matrix'

class SetableMatrix < Matrix
  public :"[]=", :set_element, :set_component
end

def generate_board(board_size)
  SetableMatrix.rows([*(1..board_size**2)].each_slice(board_size).to_a)
end

def copy_board(brd)
  max_index = brd.row_count - 1
  new_brd = SetableMatrix.identity(brd.row_count)
  0.upto(max_index).each do |i|
    0.upto(max_index).each do |j|
      new_brd[i, j] = brd.element(i, j)
    end
  end
  new_brd
end

def get_winning_lines(board)
  n = board.row_size
  winning_lines = 0.upto(n-1).each_with_object([]) do |i, arr| 
                    arr << board.row(i).to_a
                    arr << board.column(i).to_a
                  end
  winning_lines << 0.upto(n-1).collect { |i| board.element(i, i) }
  winning_lines << 0.upto(n-1).collect { |i| board.element(i, (n-1)-i) }  
  winning_lines.map do |line|
    line.map { |square| board.index(square) }
  end
end

def empty_squares(board)
  board.each_with_object([]) { |square, arr| arr << board.index(square) if square.is_a? Integer }
end

def board_full?(board)
  empty_squares(board).size == 0
end

def game_over?(winning_lines, board, players)
  winner?(winning_lines, board, players) || board_full?(board)
end

def board_empty?(brd)
  brd.all? { |square| square.is_a? Integer }
end

def winner?(winning_lines, board, players)
  !!get_winner(winning_lines, board, players)
end

def get_winner(winning_lines, board, players)
  markers = get_player_markers(players)
  winner = nil
  winning_lines.each do |line|
     line_result = line.map { |loc| board.element(*loc) }
    if line_result.all? { |i| line_result.first == i }
      winner = markers[line_result.first]
      break
    end
  end
  winner 
end

def get_player_markers(players)
  players.each_with_object({}) do |(_, details), markers|
    markers[details[:marker]] = details[:name]
  end
end

def create_players(board_size)
  max_players = (board_size/2.0).ceil
  puts "How many people are playing? Max is #{max_players}."
  num_players = gets.chomp.to_i
  players = {}
  1.upto(num_players).each do |player|
    puts "Is Player #{player} a Computer (Type 'c') or human (Type 'h')?"
    player_type = gets.chomp
    if player_type == 'h'
      player_id = "Player " + player.to_s
      players[player_id] = {}
      players[player_id][:type] = 'human'
      puts "What is the player name?"
      player_name = gets.chomp
      players[player_id][:name] = player_name
      puts "What is the player marker? Single character."
      marker = gets.chomp
      players[player_id][:marker] = marker
    end
  end
  players
end

def get_opposite_player(players, player)
  players.keys.select { |opposite| opposite != player }.first
end

def get_player_marker(players, player)
  players[player][:marker]
end

def computer_AI(brd, winning_lines, players, player, depth)
  $choice = [0,0] and return if board_empty?(brd)
  return depth - 10 if winner?(winning_lines, brd, players)
  return 0 if board_full?(brd)
  
  max = -10
  depth += 1
  scores = []
  moves = []

  empty_squares(brd).each do |square|
    new_brd = copy_board(brd)
    marker = get_player_marker(players, player)
    new_brd[*square] = marker
    opposite_player = get_opposite_player(players, player)
    scores << -1*computer_AI(new_brd, winning_lines, players, opposite_player, depth)
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


players = {"Player 1"=>{:type=>"human", :name=>"James", :marker=>"X"}, "Player 2"=>{:type=>"human", :name=>"Brad", :marker=>"O"}}

board = generate_board(3)
board[1,2] = 'O'
board[0,2] = 'X'
board[0,0] = 'O'
player = "Player 1"
wining_lines = get_winning_lines(board)
computer_AI(board, wining_lines, players, player, 0)
p $choice
p $moves
p $scores
