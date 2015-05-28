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
    @first = roster_major.players.where(position: "1B").order(sort)
    @second = roster_major.players.where(position: "2B").order(sort)
    @third = roster_major.players.where(position: "3B").order(sort)
    @ss = roster_major.players.where(position: "SS").order(sort)
    @right = roster_major.players.where(position: "RF").order(sort)
    @left = roster_major.players.where(position: "LF").order(sort)
    @center =roster_major.players.where(position: "CF").order(sort)
    
    @dhs = roster_major.players.where(position: "DH").order(sort)
    
    roster_minor =@user.rosters.find_by(minor: true)
    @pitchers_minor = roster_minor.players.where(position: "P").order(sort)
    @catchers_minor = roster_minor.players.where(position: "C").order(sort)
    @first_minor = roster_minor.players.where(position: "1B").order(sort)
    @second_minor = roster_minor.players.where(position: "2B").order(sort)
    @third_minor = roster_minor.players.where(position: "3B").order(sort)
    @ss_minor = roster_minor.players.where(position: "SS").order(sort)
    @left_minor = roster_minor.players.where(position: "LF").order(sort)
    @right_minor = roster_minor.players.where(position: "RF").order(sort)
    @center_minor = roster_minor.players.where(position: "CF").order(sort)
    @dhs_minor = roster_minor.players.where(position: "DH").order(sort)
  end
end
