class TeamScraper 
  require 'open-uri'

  def self.scrape!
    teams = %w(bal bos nyy tb tor cws cle det kc min hou ana oak sea tex atl mia nym phi was chc cin mil pit stl ari col la sd)
    #mlb players
    TeamScraper.get_mlb_players teams

    #milb players
    leagues = TeamScraper.get_milb_leagues
    team_ids = TeamScraper.get_milb_team_ids leagues
    TeamScraper.get_milb_players team_ids

    #mlb prospects
    TeamScraper.get_mlb_prospects teams
  end

  def self.get_mlb_players teams 
    teams.each do |team| 
      response = Nokogiri::HTML(open("http://mlb.com/team/roster_40man.jsp?c_id=#{team}"))
      player_data = response.css('div#roster_40_man tbody tr')
      player_data.each do |p|
        id = p.css('a')[0]['href'][/[0-9]+/].to_i
        name = p.css('a')[0].text.split(' ')
        p =Player.where(mlb_id: id).first_or_create(
          first_name: name[0].downcase, 
          last_name: name[1].downcase, 
          mlb_id: id,
          team: team
          )
      end
    end
    sleep 2
  end

  def self.get_milb_leagues
    #gets the league ids, using the VSL page, so that one gets preloaded into the league array
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
      sleep 2
    end
    teams
  end

  def self.get_milb_players team_ids
    team_ids.each do |team|
      response = `Phantomjs scraper.js #{team}`
      players= response.split("\n")
      Player.load_players players
      sleep 2
    end    
  end

  def self.get_mlb_prospects teams 
    teams.each do |team|
      response = `Phantomjs prospect_scraper.js #{team}`
      binding.pry
      players = response.split("\n")
      Player.load_players players, team
      sleep 2
    end
  end
end
