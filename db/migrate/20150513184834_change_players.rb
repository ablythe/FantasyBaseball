class ChangePlayers < ActiveRecord::Migration
  def change
    change_table :players do |t|
      t.belongs_to :roster
    end
  end
end
