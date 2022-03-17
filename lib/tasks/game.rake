namespace :game do
  desc "TODO"
  task set_names: :environment do
    # okay for now.. but ideally should order_by with pluck
    player_ids = Player.pluck(:id) - [10, 12, 18, 90] # used cards
    [
    'Ratnadeep Deshmane',
    'Animesh Ghosh',
    'Harun Kumar',
    'Alaukik Khare',
    'Arpit Mishra',
    'Deepak Chauhan',
    'Dinesh Nayak',
    'Kshitij Dhama',
    'Manish Roy',
    'Mathew Thomas',
    'Rohit Deshmane',
    'Vijay Yadav',
    'Yug Gurnani'].each_with_index do |player_name, i|
      player_id = player_ids[i]
      Player.find(player_id).update(name: player_name)
    end
  end
end
