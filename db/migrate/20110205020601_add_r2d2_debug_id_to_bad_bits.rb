class AddR2d2DebugIdToBadBits < ActiveRecord::Migration
  def self.up
    add_column :bad_bits, :r2d2_debug_id, :integer
  end

  def self.down
    remove_column :bad_bits, :r2d2_debug_id
  end
end
