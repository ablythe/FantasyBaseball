class TeamScraper 
  require 'open-uri'

  TEAMS = %w(bal bos nyy tb tor cws cle det kc min hou ana oak sea tex atl mia nym phi was chc cin mil pit stl ari col la sd sf)
  TEAMNAMES = {
   'baltimore orioles': 'bal',
   'boston red sox': 'bos',
   'new york yankees': 'nyy',  
   'tampa bay rays': 'tb',
   'toronto blue jays': 'tor',
   'chicago white sox': 'cws',
   'cleveland indians': 'cle',
   'detroit tigers': 'det',
   'kansas city royals': 'kc', 
   'minnesota twins': 'min', 
   'houston astros': 'hou', 
   'los angeles angels of anaheim': 'ana', 
   "oakland a's": 'oak', 
   'seattle mariners': 'sea',
   'texas rangers': 'tex', 
   'atlanta braves': 'atl', 
   'miami marlins': 'mia', 
   'new york mets': 'nym', 
   'philadelphia phillies': 'phi', 
   'washington nationals': 'was', 
   'chicago cubs': 'chc', 
   'cincinnati reds': 'cin', 
   'milwaukee brewers': 'mil', 
   'pittsburgh pirates': 'pit', 
   'st. louis cardinals': 'stl', 
   'arizona diamondbacks': 'ari', 
   'colorado rockies': 'col', 
   'los angeles dodgers': 'la', 
   'san diego padres': 'sd',
   'san francisco giants': 'sf'
 }

 def self.scrape!
    #mlb players
    TeamScraper.get_mlb_players 

    #milb players
    al_teams = TeamScraper.get_milb_teams_al
    nl_teams =TeamScraper.get_milb_teams_nl
    TeamScraper.get_milb_players al_teams
    TeamScraper.get_milb_players nl_teams

    #mlb prospects
    TeamScraper.get_mlb_prospects
  end

  def self.get_mlb_players 
    TEAMS.each do |team| 
      response = Nokogiri::HTML(open("http://mlb.com/team/roster_40man.jsp?c_id=#{team}"))
      player_data = response.css('div#roster_40_man tbody tr')
      player_data.each do |p|
        id = p.css('a')[0]['href'][/[0-9]+/].to_i
        name = p.css('a')[0].text.split(' ')
        first = name.shift
        last = name.join(" ")
        p =Player.where(mlb_id: id).first_or_create(
          first_name: first.downcase, 
          last_name: last.downcase, 
          mlb_id: id,
          team: team
          )
      end
    end
    sleep 2
  end

  def self.get_milb_teams_al
    teams =[]
    response = Nokogiri::HTML(open('http://www.milb.com/milb/info/affiliations.jsp'))
    al_teams = response.css('#affiliatesAL table')
    al_milb = TeamScraper.milb_team_helper al_teams
  end

  def self.get_milb_teams_nl
    teams =[]
    response = Nokogiri::HTML(open('http://www.milb.com/milb/info/affiliations.jsp'))
    nl_teams = response.css('#affiliatesNL table')
    nl_milb = TeamScraper.milb_team_helper nl_teams
  end

  def self.milb_team_helper division
    teams =[]
    division.each do |team|
      mlb = team.css('b').text.downcase.to_sym
      milb_links = team.css('a')
      milb_links.each do |link|
        if link['href'].include?('sid=t')
          id = link['href'][/[0-9]+/].to_i
          teams.push [TEAMNAMES[mlb], id]
        end
      end
    end
    teams
  end

  def self.get_milb_players teams
    teams.each do |team, id|
      response = `Phantomjs scraper.js #{id}`
      players= response.split("\n")
      Player.load_players players, team
      sleep 5
    end    
  end

  def self.get_mlb_prospects 
    TEAMS.each do |team|
      response = `Phantomjs prospect_scraper.js #{team}`
      players = response.split("\n")
      Player.load_players players, team
      sleep 2
    end
  end




end
