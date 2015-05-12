class SearchController < ApplicationController

def index
  @name = params["last_name"].downcase
  unless params["sort"]
      sort = "last_name"
    else
      sort = params["sort"]
    end
  @players = Player.where("last_name LIKE ?", "#{@name[0..3]}%").order(sort.to_sym)
end

end
