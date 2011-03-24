class AddAssemblyIdToR2d2Debugs < ActiveRecord::Migration
  def self.up
    add_column :r2d2_debugs, :assembly_id, :integer
  end

  def self.down
    remove_column :r2d2_debugs, :assembly_id
  end
end
