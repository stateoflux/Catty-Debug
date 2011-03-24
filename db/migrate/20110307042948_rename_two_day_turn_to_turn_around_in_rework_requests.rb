class RenameTwoDayTurnToTurnAroundInReworkRequests < ActiveRecord::Migration
  def self.up
    change_table :rework_requests do |t|
      t.remove :two_day_turn
      t.string :turn_around
    end
  end

  def self.down
    change_table :rework_requests do |t|
      t.boolean :two_day_turn
      t.remove :turn_around
    end
  end
end
