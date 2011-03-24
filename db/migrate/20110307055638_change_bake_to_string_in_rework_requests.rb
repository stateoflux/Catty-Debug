class ChangeBakeToStringInReworkRequests < ActiveRecord::Migration
  def self.up
    change_table :rework_requests do |t|
      t.remove :bake
      t.string :bake
    end
    
  end

  def self.down
    change_table :rework_requests do |t|
      t.remove :bake
      t.boolean :bake
    end
  end
end
