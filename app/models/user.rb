class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :players
  has_many :rosters
  has_many :team_pitching_stats_for_days

  def self.load_users_starts
    User.all.each do |u|
      u.update_starts
      self.team_pitching_stats_for_days.sum(:pitching_starts)
      sleep 5
    end
  end

  def get_player_positions
    players = self.players.all
    players.each do |player|
      player.get_position
      sleep 2
    end
  end

  def get_days_starts day
    count = 0
    yahoo_id = self.yahoo_id
    response = Nokogiri::HTML(open("http://baseball.fantasysports.yahoo.com/b1/21725/#{yahoo_id}/team?&date=#{day}"))
    pitchers = response.css('#statTable1 tbody tr')
    pitchers.each do |pitcher|
      days_stats = pitcher.text.split("\n")
      if Pitcher.started? days_stats
        count += 1
      end
    end
    count
  end

  def update_starts
    starts = 0
    today_month= DateTime.yesterday.month
    today_day = DateTime.yesterday.day
    month = 4
    month_diff = today_month - month + 1
    month_diff.times do
      unless month == today_month
        (Calendar.month_first_day(month)..Calendar.month_last_day(month)).each do |day|
          date = Date.new(2015, month, day)
          YahooTeamStartTabulator.new(self, date).go
          sleep 3
        end
      else
        (Calendar.month_first_day(month)..today_day).each do |day|
          date = Date.new(2015, month, day)
          YahooTeamStartTabulator.new(self, date).go
          sleep 3
        end
      end
      month += 1
    end
  end













end
