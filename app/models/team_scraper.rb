class TeamScraper 
  require 'open-uri'

  def self.get_mlb_players team 
    response = Nokogiri::HTML(open("http://mlb.com/team/roster_40man.jsp?c_id=#{team}"))
    player_data = response.css('div#roster_40_man tbody tr')
    player_data.each do |p|
      id = p.css('a')[0]['href'][/[0-9]+/].to_i
      name = p.css('a')[0].text.split(' ')
      p =Player.where(mlb_id: id).first_or_create(first_name: name[0], last_name: name[1], mlb_id: id)
    end
  end

  def self.get_milb_leagues
    #gets the league ids
    leagues =[['Venezualan Summer League (Rookie)', 134]]
    response = Nokogiri::HTML(open("http://www.milb.com/index.jsp?sid=l134"))
    team_data = response.css('div#other_leagues_nav li')
    team_data.each do |league|
      name = league.text[1...-1]
      id = league.css('a')[0]['href'][-3..-1].to_i
      #Mexican League doesn't use same team and player id system so must be omitted.
      unless id ==125 
        leagues.push [name, id]
      end
    end
    leagues
  end

  def self.get_milb_team_ids leagues
    teams = []
    leagues.each do |league|
      response = Nokogiri::HTML(open("http://www.milb.com/index.jsp?sid=l#{league[1]}"))
      links = response.xpath('//a[@href[contains(.,"index.jsp?sid=t")]]')
      links.each do |link|
        name = link.text
        id = link['href'][/[0-9]+/].to_i
        teams.push id
      end
      sleep 1
    end
    teams
  end

  def self.get_milb_players team_ids
    team_ids.each do |team|
      response = `Phantomjs scraper.js #{team}`
      players= response.split("\n")
      players.each do |player|
        p =player.split(', ')
        id = p[0][/[0-9]+/].to_i
        name = p[1].split(" ")
        p = Player.where(mlb_id: id).first_or_create(
          first_name: name[0], 
          last_name: name[1], 
          mlb_id: id
          )
      end
      sleep 2
    end    
  end
end
