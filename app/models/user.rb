class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :players
  has_many :rosters

  def self.load_starts
    User.all.each do |u|
      TeamScraper.past_starts u.id
    end 
  end
  
end
