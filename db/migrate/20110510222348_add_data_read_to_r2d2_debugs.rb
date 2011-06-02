class AddDataReadToR2d2Debugs < ActiveRecord::Migration
  def self.up
    add_column :r2d2_debugs, :data_read, :text
  end

  def self.down
    remove_column :r2d2_debugs, :data_read
  end
end
