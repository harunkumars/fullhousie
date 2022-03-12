class GameSession < ApplicationRecord
  belongs_to :game
  belongs_to :player
  has_many :cards, dependent: :destroy

  after_create :create_card

  def create_card
    self.cards.create!
  end
end
