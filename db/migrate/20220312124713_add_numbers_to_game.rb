class AddNumbersToGame < ActiveRecord::Migration[6.1]
  def change
    add_column :games, :numbers, :jsonb, default: []
  end
end
