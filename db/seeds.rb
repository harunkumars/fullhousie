# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

game = Game.create!(name: Time.now)

20.times do |i|
  player = Player.create!(name: "Player_#{i+1}")
  game.game_sessions.create!(player: player)
end

game.start

