class CreateTeamPitchingStatsForDays < ActiveRecord::Migration
  def change
    create_table :team_pitching_stats_for_days do |t|
      t.references :user, index: true
      t.date :date, null: false
      t.integer :pitching_starts, null: false, default: 0

      t.timestamps null: false
    end

    add_foreign_key :team_pitching_stats_for_days, :users
    add_index :team_pitching_stats_for_days, [:user_id, :date], unique: true
  end
end
