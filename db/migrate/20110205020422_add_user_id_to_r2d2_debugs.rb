class AddUserIdToR2d2Debugs < ActiveRecord::Migration
  def self.up
    add_column :r2d2_debugs, :user_id, :integer
  end

  def self.down
    remove_column :r2d2_debugs, :user_id
  end
end
