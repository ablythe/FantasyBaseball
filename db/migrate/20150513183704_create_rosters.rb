class CreateRosters < ActiveRecord::Migration
  def change
    create_table :rosters do |t|
      t.belongs_to :user
      t.belongs_to :roster
      t.boolean :forty_five
      t.boolean :minor
    end
  end
end
