class RemoveR2d2DebugIdFromBadBits < ActiveRecord::Migration
  def self.up
    remove_column :bad_bits, :r2d2_debug_id
  end
  
  def self.down
    add_column :bad_bits, :r2d2_debug_id, :integer
  end
end
