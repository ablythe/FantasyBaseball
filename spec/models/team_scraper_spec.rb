require 'rails_helper'

RSpec.describe TeamScraper, type: :model do
  it "can get milb team names" do
    al_teams =TeamScraper.get_milb_teams_al
    nl_teams = TeamScraper.get_milb_teams_nl 
    teams = al_teams + nl_teams
    expect(teams.length).to eq 232
  end
end
