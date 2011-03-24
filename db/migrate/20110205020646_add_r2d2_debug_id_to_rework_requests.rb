class AddR2d2DebugIdToReworkRequests < ActiveRecord::Migration
  def self.up
    add_column :rework_requests, :r2d2_debug_id, :integer
  end

  def self.down
    remove_column :rework_requests, :r2d2_debug_id
  end
end
