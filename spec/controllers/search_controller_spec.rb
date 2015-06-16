require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  render_views
  before :each do
    @user = FactoryGirl.create :user
    login @user
  end

  
end
