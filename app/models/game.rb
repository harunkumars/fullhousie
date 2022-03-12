class Game < ApplicationRecord
  has_many :game_sessions, dependent: :destroy
  has_many :players, through: :game_sessions
  has_many :cards, through: :game_sessions
  has_many :lotteries, dependent: :destroy

  rich_enum status: {
    new: 0,
    started: 10,
    ended: 20
  }, _prefix: true

  def next_number
    lot = (numbers - lotteries.first.numbers)
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
    lotteries.create
    self.status_started!
  end

  def end
    self.status_ended!
    cards.each &:tally
  end
end
