class RostersController < ApplicationController

  def index
    @users = User.all
  end

  def show
    @user = User.find(params["id"])
    unless params["sort"]
      sort = "last_name"
    else
      sort = params["sort"].to_sym
    end
    roster_major = @user.rosters.find_by(forty_five: true)
    @pitchers = roster_major.players.where(position: "P").order(sort)
    @catchers = roster_major.players.where(position: "C").order(sort)
    @infielders = roster_major.players.where("position LIKE ?", "%B").order(sort)
    ss = roster_major.players.where(position: "SS").order(sort)
    ss.each do |p|
      @infielders.push p 
    end
    @outfielders = roster_major.players.where("position LIKE ?", "%F").order(sort)
    @dhs = roster_major.players.where(position: "DH").order(sort)
    
    roster_minor =@user.rosters.find_by(minor: true)
    @pitchers_minor = roster_minor.players.where(position: "P").order(sort)
    @catchers_minor = roster_minor.players.where(position: "C").order(sort)
    @infielders_minor = roster_minor.players.where("position LIKE ?", "%B").order(sort)
    ss_minors = roster_minor.players.where(position: "SS").order(sort)
    ss_minors.each do |p|
      @infielders_minor.push p 
    end
    @outfielders_minor = roster_minor.players.where("position LIKE ?", "%F").order(sort)
    @dhs_minor = roster_minor.players.where(position: "DH").order(sort)
  end
end
