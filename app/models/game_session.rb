class GameSession < ApplicationRecord
  belongs_to :game
  belongs_to :player
  has_one :card, dependent: :destroy

  after_create :create_card!
end
