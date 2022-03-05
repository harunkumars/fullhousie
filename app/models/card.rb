class Card < ApplicationRecord
  belongs_to :game_session

  after_initialize :populate_grid

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
end
