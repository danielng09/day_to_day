
class Piece

  attr_reader :pos, :color, :king

  def initialize(pos, color, board)
    @pos, @color, @board = pos, color, board
    @king = false
    @board.place_piece(@pos, self)
  end

  UP_DIR = [
    [-1,-1],
    [-1, 1]
  ]

  DOWN_DIR = [
    [1,-1],
    [1, 1]
  ]

  def move_diffs
    return UP_DIR.concat(DOWN_DIR) if kinged?
    case @color
    when :white
      DOWN_DIR
    when :black
      UP_DIR
    end
  end

  def slide_moves
    move_diffs.map do |diff|
      # puts "pos: #{pos} : diff: #{diff} : added: #{[diff.first + pos.first, diff.last + pos.first]}"
      [diff.first + pos.first, diff.last + pos.last]
    end.reject do |spot|
      !@board.empty?(spot)
    end.select do |spot|
      Board.on_board?(spot)
    end
  end

  def hop_moves
    hoppable_opponent = move_diffs.map do |diff|
      # puts "pos: #{pos} : diff: #{diff} : added: #{[diff.first + pos.first, diff.last + pos.first]}"
      [diff.first + pos.first, diff.last + pos.last]
    end.reject do |pos|
      @board.empty?(pos)
    end.reject do |pos|
      @board.find_piece(pos).color == color
    end

    hoppable_opponent.map do |start|
      diff = [start.first - pos.first, start.last - pos.last]
      [start.first + diff.first, start.last + diff.last]
    end
  end

  def perform_slide(end_pos)
     if slide_moves.include?(end_pos)
       @board.move(pos, end_pos)
       @board.delete(pos)
       @pos = end_pos
     else
       raise "Not a valid slide move"
     end
  end

  def perform_jump(end_pos)
    if hop_moves.include?(end_pos)
      @board.move(pos, end_pos)
      @board.delete(pos)
      remove_hopped_piece(end_pos)
      @pos = end_pos
    else
      raise "Not a valid hop move"
    end
  end

  def remove_hopped_piece(end_pos)
    hopped_pos = [(end_pos.first + pos.first)/2, (end_pos.last + pos.last)/2]
    # puts "pos: #{pos} : end_pos: #{end_pos} : hopped_pos: #{hopped_pos}"
    @board.delete(hopped_pos)
  end

  def promote?
    case color
    when :white
      pos.first == 7
    when :red
      pos.first == 0
    end
  end

  def render_piece
    if @color == :white
      print kinged? ? "\u265B" : "\u2617" #"\u26AA"
    elsif @color == :red
      print kinged? ? "\u2655" : "\u2616" #"\u26AB".colorize(color => :blue)
    end
  end

  def kinged?
    @king
  end

end
