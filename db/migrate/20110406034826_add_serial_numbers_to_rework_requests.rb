class AddSerialNumbersToReworkRequests < ActiveRecord::Migration
  def self.up
    add_column :rework_requests, :serial_numbers, :string
  end

  def self.down
    remove_column :rework_requests, :serial_numbers
  end
end
