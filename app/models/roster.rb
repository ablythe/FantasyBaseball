class Roster <ActiveRecord::Base
  belongs_to :user
  has_many :players

  def self.create_rosters
    users = User.all
    users.each do |u|
      u.rosters.create(forty_five: true)
      u.rosters.create(minor: true)
    end     
  end

  def load_players names, id, level
    unknowns =[]
    roster = User.find(id).rosters.find_by("#{level}": true)
    names.each do |first, last|
      player = Player.where(last_name: last, first_name: first)
      unless player.count > 1 || player.empty?
        player[0].update(user_id: id, roster_id: roster.id )
      else
        unknowns.push [last, first]
      end
    end
    unknowns
  end
    
end