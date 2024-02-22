class Game < ApplicationRecord
  has_many :game_sessions, dependent: :destroy
  has_many :players, through: :game_sessions
  has_many :cards, through: :game_sessions
  has_one :lottery, dependent: :destroy

  accepts_nested_attributes_for :players

  rich_enum status: {
    new: 0,
    started: 10,
    ended: 20
  }, _prefix: true

  def next_number
    lot = (numbers - lottery.numbers)
    if lot.empty?
      status_ended!
      0
    else
      lot.sample
    end
  end


  def numbers_from_all_cards
    number_array = []
    cards.each { |card| number_array.push(*card.numbers) }
    number_array
  end

  def start
    self.numbers = numbers_from_all_cards
    create_lottery!
    self.status_started!
  end

  def end
    self.status_ended!
    cards.each &:tally
  end

  def self.ransackable_associations(auth_object = nil)
    ["cards", "game_sessions", "lottery", "players"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "id_value", "last_number", "name", "numbers", "status", "updated_at"]
  end
end
