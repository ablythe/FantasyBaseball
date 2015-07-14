require "rails_helper"

RSpec.describe YahooTeamStartTabulator do
  describe "#go" do
    it "creates a user's start count for the date" do
      user = FactoryGirl.create(:user, email: "andrew.blythe@gmail.com", yahoo_id: 8)
      query_date = Date.new(2015, 5, 1)

      described_class.new(user, query_date).go

      expect(
        TeamPitchingStatsForDay.
          find_by(user: user, date: query_date).
          pitching_starts
      ).to eq(2)
    end

    it "updates a user's start count for the date if one already exists" do
      user = FactoryGirl.create(:user, email: "andrew.blythe@gmail.com", yahoo_id: 8)
      query_date = Date.new(2015, 5, 1)
      FactoryGirl.create(
        :team_pitching_stats_for_day,
        user: user,
        date: query_date,
        pitching_starts: 1
      )

      described_class.new(user, query_date).go

      expect(
        TeamPitchingStatsForDay.
          find_by(user: user, date: query_date).
          pitching_starts
      ).to eq(2)
    end
  end
end
