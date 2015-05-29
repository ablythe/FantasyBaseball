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
    if params["last_name"]
      @name = params["last_name"].downcase
      @results = Player.where("last_name LIKE ?", "#{@name}%")
      if @results.empty?
        @results = Player.where("last_name LIKE ?", "#{@name[0..2]}%")
      end
      @players = @results.page(@page).order(sort.to_sym)
    else
      @players = Player.page(@page).order(sort.to_sym)
    end
  end

  def claim
    @player = Player.find(params['id'])
    @user = current_user
    @major = @user.rosters.find_by(forty_five: true)
    @minor = @user.rosters.find_by(minor: true)
  end
end
