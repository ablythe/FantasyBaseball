class PlayersController < ApplicationController

  def index
    unless params["sort"]
      sort = "last_name"
    else
      sort = params["sort"]
    end
    unless params["page"]
      @page = 1
    else
      @page = params["page"].to_i
    end
    @players = Player.page(@page).order(sort.to_sym)

  end
end
