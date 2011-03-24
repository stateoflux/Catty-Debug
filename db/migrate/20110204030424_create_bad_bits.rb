class CreateBadBits < ActiveRecord::Migration
  def self.up
    create_table :bad_bits do |t|
      t.integer :bad_bit

      t.timestamps
    end
  end

  def self.down
    drop_table :bad_bits
  end
end
