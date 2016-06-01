require "open-uri"

class YahooTeamStartTabulator
  def initialize(user, date)
  	@user = user
  	@date = date
  end

  def go
  	record.update!(pitching_starts: pitching_starts)
  end

  protected

  attr_reader :date, :user

  private

  delegate :yahoo_id, to: :user

  def record
	  TeamPitchingStatsForDay.find_or_initialize_by(user: user, date: date)
  end

  def api_response
	   Nokogiri::HTML(open("http://baseball.fantasysports.yahoo.com/b1/14626/#{yahoo_id}/team?&date=#{date}"))
  end

  def pitchers
	  api_response.css('#statTable1 tbody tr')
  end

  def pitching_starts
    pitchers.inject(0) do |count, pitcher|
      days_stats = pitcher.text.split("\n")

      if Pitcher.started?(days_stats)
        count += 1
      end
      count

    end
  end
end