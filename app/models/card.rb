class Card < ApplicationRecord
  belongs_to :game_session
  before_create :populate_grid

  def populate_grid
    self.grid = {
      first_row: CardRow.new(row_type: :first_row),
      middle_row: CardRow.new(row_type: :middle_row),
      last_row: CardRow.new(row_type: :last_row)
    }
  end

  def tabulate
    grid['first_row']['cells'].each { |e| print "#{e['number'].to_s.rjust(2)}|" }
    puts "\n#{'-' * 27}"
    grid['middle_row']['cells'].each { |e| print "#{e['number'].to_s.rjust(2)}|" }
    puts "\n#{'-' * 27}"
    grid['last_row']['cells'].each { |e| print "#{e['number'].to_s.rjust(2)}|" }
  end

  def game
    game_session.game
  end

  def status_helper(cell = {})
    case cell['status']
    when -1
      'blocked'
    when 1
      'checked'
    else
      'default'
    end
  end

  def numbers
    numbers = []
    %w[first_row middle_row last_row].each do |row|
      self.grid[row]['cells'].each do |cell|
        numbers.push cell['number'] if cell['number'].positive?
      end
    end
    numbers
  end

  def tally
    picked_lots = game.lottery.numbers
    %w[first_row middle_row last_row].each do |row|
      self.grid[row]['cells'].each do |cell|
        cell['status'] = 1 if picked_lots.include?(cell['number'])
      end
    end
    save!
  end

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "game_id", "id", "id_value", "player_id", "updated_at"]
  end
end
