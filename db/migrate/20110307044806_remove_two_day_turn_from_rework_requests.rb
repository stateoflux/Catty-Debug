class RemoveTwoDayTurnFromReworkRequests < ActiveRecord::Migration
  def self.up
    remove_column :rework_requests, :two_day_turn
  end

  def self.down
    add_column :rework_requests, :two_day_turn, :boolean
  end
end
