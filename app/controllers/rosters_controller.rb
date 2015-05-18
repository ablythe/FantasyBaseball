class RostersController < ApplicationController

  def index
    @users = User.all
  end

  def show
    @user = User.find(params["id"])
    unless params["sort"]
      sort = "last_name"
    else
      sort = params["sort"]
    end
    @pitchers = @user.rosters.find_by(forty_five: true).players.where(position: "P").order(sort.to_sym)
    @catchers = @user.rosters.find_by(forty_five: true).players.where(position: "C").order(sort.to_sym)
    @infielders = @user.rosters.find_by(forty_five: true).players.where("position LIKE ?", "%B").order(sort.to_sym)
    @outfielders = @user.rosters.find_by(forty_five: true).players.where("position LIKE ?", "%F").order(sort.to_sym)
    @dhs = @user.rosters.find_by(forty_five: true).players.where(position: "DH").order(sort.to_sym)

    @pitchers_minor = @user.rosters.find_by(minor: true).players.where(position: "P").order(sort.to_sym)
    @catchers_minor = @user.rosters.find_by(minor: true).players.where(position: "C").order(sort.to_sym)
    @infielders_minor = @user.rosters.find_by(minor: true).players.where("position LIKE ?", "%B").order(sort.to_sym)
    @outfielders_minor = @user.rosters.find_by(minor: true).players.where("position LIKE ?", "%F").order(sort.to_sym)
    @dhs_minor = @user.rosters.find_by(minor: true).players.where(position: "DH").order(sort.to_sym)
  end
end
