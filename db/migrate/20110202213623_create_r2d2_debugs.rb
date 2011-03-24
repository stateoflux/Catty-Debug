class CreateR2d2Debugs < ActiveRecord::Migration
  def self.up
    create_table :r2d2_debugs do |t|
      t.integer :r2d2_instance
      t.string :interface
      t.string :serial_number

      t.timestamps
    end
  end

  def self.down
    drop_table :r2d2_debugs
  end
end
