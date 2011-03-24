class CreateRxMemories < ActiveRecord::Migration
  def self.up
    create_table :rx_memories do |t|
      t.integer :r2d2_id
      t.string :part_number
      t.integer :instance
      t.string :refdes

      t.timestamps
    end
  end

  def self.down
    drop_table :rx_memories
  end
end
