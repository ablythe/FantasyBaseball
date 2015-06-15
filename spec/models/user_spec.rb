require 'rails_helper'

RSpec.describe User, type: :model do
  before :each do
    @user = FactoryGirl.create :user
  end

  it "can load a users starts" do 
    expect(@user.starts).to eq 0
    @user.update_starts
    expect(@user.starts).to be > 0
  end

  

end
