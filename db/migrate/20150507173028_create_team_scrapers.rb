class CreateTeamScrapers < ActiveRecord::Migration
  def change
    create_table :team_scrapers do |t|

      t.timestamps null: false
    end
  end
end
