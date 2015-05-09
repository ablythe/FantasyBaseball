
teams = %w(bal bos nyy tb tor cws cle det kc min hou ana oak sea tex atl mia nym phi was chc cin mil pit stl ari col la sd)
teams.each do |team|
  TeamScraper.get_players team
  sleep 5
end
