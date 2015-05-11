class SearchController < ApplicationController

def index
  @name = params["last_name"].downcase
  @players = Player.where(last_name: @name)
  if @players.empty? 
    @players = Player.where("last_name LIKE ?", "#{@name[0..2]}%")
  end
end

end
