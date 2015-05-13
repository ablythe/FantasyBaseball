class SearchController < ApplicationController

def index
  @name = params["last_name"].downcase
  unless params["sort"]
      sort = "last_name"
    else
      sort = params["sort"]
    end
  @players = Player.where("last_name LIKE ?", "#{@name}%").order(sort.to_sym)
  if @players.empty?
    @players = Player.where("last_name LIKE ?", "#{@name[0..2]}%")
  end
end

end
