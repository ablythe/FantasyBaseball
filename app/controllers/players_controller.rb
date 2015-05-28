class PlayersController < ApplicationController
  skip_before_filter :authenticate_user!
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

  def claim
    @player = Player.find(params['id'])
    @user = current_user
    @major = @user.rosters.find_by(forty_five: true)
    @minor = @user.rosters.find_by(minor: true)
  end
end
