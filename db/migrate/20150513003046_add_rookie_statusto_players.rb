class AddRookieStatustoPlayers < ActiveRecord::Migration
  def change
    change_table :players do |t|
      t.boolean :rookie_status, default: false
    end
  end
end
