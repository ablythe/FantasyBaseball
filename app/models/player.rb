class Player < ActiveRecord::Base

  def self.load_players players, team 
   players.each do |player|
    p =player.split(', ')
    id = p[0][/[0-9]+/].to_i
    name = p[1].split(" ")
    p = Player.where(mlb_id: id).first_or_create(
      first_name: name[0].downcase, 
      last_name: name[1].downcase, 
      mlb_id: id,
      team: team
      )
    end
  end



end
