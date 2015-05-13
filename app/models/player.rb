class Player < ActiveRecord::Base
  belongs_to :user 

  def self.load_players players, team 
   players.each do |player|
    p =player.split(', ')
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
      names.push [first, last]
    end
    names
  end

  def self.load_rosters names, id
    unknowns =[]
    names.each do |first, last|
      player = Player.where(last_name: last)
      if player.empty? 
        unknowns.push [last, first]
      elsif player.count > 1
        player = Player.where(last_name: last, first_name: first)
        unless player.count > 1 || player.empty?
          player[0].update(user_id: id)
        else
          unknowns.push [last, first]
        end
      else
        player[0].update(user_id: id)
      end 
    end
    unknowns
  end

  def self.parse_rookie_file file
    names = []
    f =File.open("./#{file}", "r")
    f.each_line do |line|
      line_array =line.split(",")
      names.push line_array[1]
    end
    names
  end

  def self.load_rookie_eligibility names
    unknowns =[]
    Player.update_all(rookie_status: false)
    names.each do |name|
      name_array = name.split(" ")
      matches= Player.where(first_name: name_array[0], last_name: name_array[1])
      if matches.count > 1 || matches.empty?
        unknowns.push names
      else
        matches[0].update!(rookie_status: true)
      end
    end
    unknowns
  end

end
