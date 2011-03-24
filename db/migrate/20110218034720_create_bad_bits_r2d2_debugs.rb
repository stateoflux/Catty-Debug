class CreateBadBitsR2d2Debugs < ActiveRecord::Migration
  def self.up
    create_table :bad_bits_r2d2_debugs, :id => false do |t|
      t.references :bad_bit
      t.references :r2d2_debug
    end
  end

  def self.down
    drop_table :bad_bits_r2d2_debugs
  end
end
