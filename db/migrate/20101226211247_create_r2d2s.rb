class CreateR2d2s < ActiveRecord::Migration
  def self.up
    create_table :r2d2s do |t|
      t.integer :assembly_id
      t.string :part_number
      t.integer :instance
      t.string :refdes

      t.timestamps
    end
  end

  def self.down
    drop_table :r2d2s
  end
end
