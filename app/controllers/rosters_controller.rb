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
    @pitchers = @user.players.where(position: "P").order(sort.to_sym)
    @catchers = @user.players.where(position: "C").order(sort.to_sym)
    @infielders = @user.players.where("position LIKE ?", "%B").order(sort.to_sym)
    @outfielders = @user.players.where("position LIKE ?", "%F").order(sort.to_sym)
    @dhs = @user.players.where(position: "DH").order(sort.to_sym)
  end
end
