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
      starts = u.team_pitching_stats_for_days.sum(:pitching_starts)
      u.update!(starts: starts)
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
    response = Nokogiri::HTML(open("http://baseball.fantasysports.yahoo.com/b1/14626/#{yahoo_id}/team?&date=#{day}"))
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
    last_update = Date.parse('2016-04-05')
    unless self.team_pitching_stats_for_days.length == 0
      last_update = self.team_pitching_stats_for_days.last.date
      binding.pry
    end
    binding.pry
    yesterdays_date = Date.yesterday
    dates_since_last_check = (last_update..yesterdays_date).map(&:to_s)
    dates_since_last_check.each do |day|
      YahooTeamStartTabulator.new(self, day).go
    end
  end



  # def update_starts
  #   starts = 0
  #   last_update_month = TeamPitchingStatsForDay.last.date.month
  #   last_update_day = TeamPitchingStatsForDay.last.date.day
  #   today_month= DateTime.yesterday.month
  #   today_day = DateTime.yesterday.day
  #   if last_update_month == nil
  #     last_update_month = 4
  #     last_update_day = 5
  #   end
  #   month_diff = today_month - last_update_month + 1
  #   month = last_update_month
  #   month_diff.times do
  #     unless last_update_month == today_month
  #       (Calendar.month_first_day(month)..Calendar.month_last_day(month)).each do |day|
  #         date = Date.new(2015, month, day)
  #         YahooTeamStartTabulator.new(self, date).go
  #         sleep 3
  #       end
  #     else
  #       (last_update_day..today_day).each do |day|
  #         date = Date.new(2015, month, day)
  #         YahooTeamStartTabulator.new(self, date).go
  #         sleep 3
  #       end
  #     end
  #     month += 1
  #   end
  # end
end
