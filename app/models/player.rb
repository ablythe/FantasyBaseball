require 'open-uri'
class Player < ActiveRecord::Base
  belongs_to :user 
  belongs_to :roster

  def self.load_players players, team 
   players.each do |player|
    p = player.split(', ')
    id = p[0][/[0-9]+/].to_i
    name = p[1].split(" ")
    first = name.shift
    last = name.join(" ")
    p = Player.where(mlb_id: id).first_or_create(
      first_name: first.downcase, 
      last_name: last.downcase, 
      mlb_id: id,
      team: team
      )
    end
  end

  def self.parse_roster_names file
    names = []
    f = File.open("./rosters/#{file}", "r")
    f.each_line do |line|
      names.push Player.clean_lines line
    end
    names
  end

  def self.clean_lines line
    line.gsub!(/\W(...)\W\s+/, "")
      if line.include?(",")
        name = line.split(", ")
        first = name[1].strip.downcase
        last  = name[0].downcase
      else
        name = line.split(" ")
        first = name.shift.downcase
        last  = name.join(" ").strip.downcase
      end
    return [first, last]
  end

  def get_position 
    unless mlb_id == 0
        response = Nokogiri::HTML(open("http://mlb.mlb.com/team/player.jsp?player_id=#{mlb_id}"))
        position = response.css('div.player-vitals li').first.text
        update!(position: position)
      end
  end

  def self.full_search last, first, team
    results = Player.
          where("last_name LIKE ? and first_name LIKE ? and team = ?", 
            "#{last[0..3]}%",
            "#{first[0..3]}%",
            "#{team}"
            )
  end

  def self.full_name_search last, first
    results = Player.
            where("last_name LIKE ? and first_name LIKE ?", 
            "#{last[0..3]}%",
            "#{first[0..3]}%"
            )
  end

  def self.search options
    if options[:last_name] && options[:first_name] && options[:team] 
      results = Player.full_search options[:last_name], options[:first_name], options[:team]
    elsif options[:last_name] && options[:first_name]
      results = Player.full_name_search options[:last_name], options[:first_name]
    elsif options[:first_name] && options[:team]
      results = Player.
          where("first_name LIKE ? and team = ?", 
            "#{options['first_name'][0..3]}%",
            "#{options['team']}"
            )
    elsif options[:last_name] && options[:team] 
      results = Player.
          where("last_name LIKE ? and team = ?", 
            "#{options['last_name'][0..3]}%",
            "#{options['team']}"
            )
    elsif options[:last_name]
      results = Player.where("last_name LIKE ?","#{options['last_name'][0..3]}%")
    elsif options[:first_name]
      results = Player.where("first_name LIKE ?","#{options['first_name'][0..3]}%")
    elsif options[:team]
      results = Player.where(team: "#{options['team']}")      
    end
    results
  end

end
