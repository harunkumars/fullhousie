
STDOUT.puts "Enter Game Name (e.g. Meetup Feb 2024): "
game_name = STDIN.gets.chomp
game = Game.create!(name: game_name.strip.presence || Time.now)

STDOUT.puts "Enter number of players (default 5): "
num_players = STDIN.gets.chomp.to_i
num_players = num_players.positive? ? num_players : 5

num_players.times do |i|
  STDOUT.puts "Enter Player Name (default: Player_#{i+1}): "
  player_name = STDIN.gets.chomp

  player = Player.create!(name: player_name.strip.presence || "Player_#{i+1}")
  game.game_sessions.create!(player: player)
end

game.start
STDOUT.puts "Game #{game.name} started with #{game.players.count} players."
STDOUT.puts "Share the following card link to each player:"
game.game_sessions.each do |game_session|
  STDOUT.puts "#{game_session.player.name}: /cards/#{game_session.card.to_param}"
end
STDOUT.puts "Game #{game.name} is ready to play!"
STDOUT.puts "Game master can visit the following link to view the game:"
STDOUT.puts "/games/#{game.to_param}"

STDOUT.puts "Seed complete!"
AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?