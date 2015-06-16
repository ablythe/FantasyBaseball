require 'rails_helper'

RSpec.describe Roster, type: :model do
  it "can create rosters for users" do
    expect(Roster.count).to eq 0
    5.times do |i|
      FactoryGirl.create :user
    end 
    Roster.create_rosters
    expect(Roster.count).to eq 10
  end

  
end