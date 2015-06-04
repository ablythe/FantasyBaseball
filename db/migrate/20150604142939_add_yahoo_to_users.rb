class AddYahooToUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.integer :yahoo_id
    end
  end
end
