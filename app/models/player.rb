require 'open-uri'
class Player < ActiveRecord::Base
  belongs_to :user
  belongs_to :roster

  def self.load_players players, team
   players.each do |player|
    p = player.split(', ')
    id = p[0][/[0-9]+/].to_i
    name = p[1]
    Player.find_or_create_player id, name, team
    end
  end

  def self.find_or_create_player id, name, team
    first, last = Player.split_name name
    Player.where(mlb_id: id).first_or_create(
      first_name: first,
      last_name: last,
      mlb_id: id,
      team: team
    )
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
    [first, last] = Player.split_name line
  end

  def self.split_name full_name
    if full_name.include?(",")
      name = full_name.split(", ")
      first = name[1].strip
      last  = name[0]
    else
      name = full_name.split(" ")
      first = name.shift
      last  = name.join(" ").strip
    end
    first.downcase, last.downcase
  end

  def get_position
    return unless mlb_id != 0

    response = Nokogiri::HTML(open("http://mlb.mlb.com/team/player.jsp?player_id=#{mlb_id}"))
    position = response.css('div.player-vitals li').first.text
    update!(position: position)
  end

  def self.full_search last, first, team
    Player.where("last_name LIKE ? and first_name LIKE ? and team = ?",
            "#{last[0..3]}%",
            "#{first[0..3]}%",
            "#{team}"
            )
  end

  def self.full_name_search last, first
    Player.where("last_name LIKE ? and first_name LIKE ?",
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
      results = Player.where("first_name LIKE ? and team = ?",
            "#{options['first_name'][0..3]}%",
            "#{options['team']}"
            )
    elsif options[:last_name] && options[:team]
      results = Player.where("last_name LIKE ? and team = ?",
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
