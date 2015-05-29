class SearchController < ApplicationController

  def create
    unless params["first_name"] == "" || params["first_name"] == nil
      @first_name = params["first_name"].downcase
    else
      @first_name = nil
    end
    unless params["team"] == "" || params["team"] == nil
      @team = params["team"].downcase
    else
      @team = nil
    end
    unless params["last_name"] == "" || params["last_name"] == nil
      @last_name = params["last_name"].downcase
    else
      @last_name = nil
    end
    
    redirect_to search_index_path(last_name: @last_name, first_name: @first_name, team: @team)
  end

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
    @first_name = params["first_name"]
    @last_name = params["last_name"]
    @team =params["team"]
    results =Player.search params
    @players = results.page(@page).order(sort.to_sym)
  end

  def new
  end

end
