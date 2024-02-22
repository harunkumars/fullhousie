class GameSession < ApplicationRecord
  belongs_to :game
  belongs_to :player
  has_one :card, dependent: :destroy

  after_create :create_card!

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "game_id", "id", "id_value", "player_id", "updated_at"]
  end
end
