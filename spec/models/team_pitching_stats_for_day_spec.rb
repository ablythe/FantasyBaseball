require "rails_helper"

RSpec.describe TeamPitchingStatsForDay, type: :model do
  it { should belong_to(:user) }

  it { should validate_presence_of(:date) }
  it { should validate_presence_of(:pitching_stats) }
  it { should validate_presence_of(:user) }

  it { should validate_uniqueness_of(:date).scoped_to(:user_id) }
end
