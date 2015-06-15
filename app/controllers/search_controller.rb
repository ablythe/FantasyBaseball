class SearchController < ApplicationController
  skip_before_filter :authenticate_user!
  def create
    new_params = {
      first_name: params['first_name'], 
      last_name: params['last_name'],
      team: params['team']
    }
    new_params.each do |k,v| 
      if v == "" || v == nil
        new_params[k] = nil
      else
        new_params[k] = v.downcase
      end
    end
    redirect_to search_index_path(new_params)
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
