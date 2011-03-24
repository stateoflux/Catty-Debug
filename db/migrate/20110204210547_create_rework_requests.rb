class CreateReworkRequests < ActiveRecord::Migration
  def self.up
    create_table :rework_requests do |t|
      t.string :board_name
      t.boolean :two_day_turn
      t.text :instructions
      t.boolean :bake

      t.timestamps
    end
  end

  def self.down
    drop_table :rework_requests
  end
end
