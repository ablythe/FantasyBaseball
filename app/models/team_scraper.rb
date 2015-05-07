class TeamScraper 
  require 'open-uri'

  def self.get_players team 
    players =[]
    response = Nokogiri::HTML(open("http://losangeles.angels.mlb.com/team/roster_40man.jsp?c_id=#{team}"))
    player_data = response.css('div#roster_40_man tbody tr')
    player_data.each do |p|
      id = p.css('a')[0]['href'][/[0-9]+/]
      name = p.css('a')[0].text
      players.push [id, name]
    end
    players
  end

end
