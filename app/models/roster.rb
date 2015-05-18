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
    
end