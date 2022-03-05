class CreateCardRow < ActiveRecord::Migration[6.1]
  def change
    create_table :card_rows do |t|
      t.references :card, null: false, foreign_key: true
      t.integer :row_type, default: 1
      t.jsonb :cells

      t.timestamps
    end
  end
end
