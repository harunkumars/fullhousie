class AddMoreFieldsToGame < ActiveRecord::Migration[6.1]
  def change
    add_column :games, :status, :integer, default: 0
    add_column :games, :last_number, :integer, default: 0
  end
end
