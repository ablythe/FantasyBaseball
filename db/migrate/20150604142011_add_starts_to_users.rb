class AddStartsToUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.integer :starts, default: 0
    end
  end
end
