require 'rails_helper'

RSpec.describe PlayersController, type: :controller do
  render_views
  before :each do
    @player = Player.create()
    @user =FactoryGirl.create :user
    login @user
    @user.rosters.create(forty_five: true)
    @user.rosters.create(minor: true)
  end

  it "can claim a player" do
    get :index, id: @player
    expect(response.code.to_i).to eq 200
  end
end
