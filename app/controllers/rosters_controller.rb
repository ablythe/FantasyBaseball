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
    @roster_major = @user.
                    rosters.find_by(forty_five: true).
                    players.all.order(sort)
    @roster_minor = @user.
                    rosters.find_by(minor: true).
                    players.all.order(sort)
    @count = @roster_major.count + @roster_minor.count
  end

  def update
    player = Player.find(params['player_id'])
    if player.roster_id? && player.user_id == current_user.id
      player.update(roster_id: nil, user_id: nil)
    elsif player.roster_id? && player.user_id != current_user.id
      redirect_to roster_path(current_user.rosters.first), alert: "Drop failed. Player does not belong to you"
    else
      player.update(roster_id: params["id"], user_id: current_user.id)
      unless player.position
        player.get_position
      end
    end
    redirect_to roster_path(current_user.rosters.first), alert: "Roster Updated"
  end

  
end
