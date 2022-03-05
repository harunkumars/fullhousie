class Game < ApplicationRecord
  has_many :game_sessions
  has_many :players, through: :game_sessions
  has_many :cards, through: :game_sessions
end
