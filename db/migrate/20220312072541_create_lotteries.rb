class CreateLotteries < ActiveRecord::Migration[6.1]
  def change
    create_table :lotteries do |t|
      t.jsonb :numbers, default: []
      t.references :game, null: false, foreign_key: true

      t.timestamps
    end
  end
end
