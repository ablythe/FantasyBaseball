
teams = %w(bal bos nyy tb tor cws cle det kc min hou ana oak sea tex atl mia nym phi was chc cin mil pit stl ari col la sd)
teams.each do |team|
  TeamScraper.get_mlb_players team
  sleep 5
end

leagues = TeamScraper.get_milb_leagues
team_ids = TeamScraper.get_milb_team_ids leagues
TeamScraper.get_milb_players team_ids
