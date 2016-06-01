class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.integer :mlb_id
      t.string :first_name
      t.string :last_name
      t.belongs_to :roster
      t.string :team
      t.string :position
      t.boolean :rookie_status, default: false

      t.timestamps null: false
    end
  end
end
