class AddXrayToReworkRequests < ActiveRecord::Migration
  def self.up
    add_column :rework_requests, :xray, :string
  end

  def self.down
    remove_column :rework_requests, :xray
  end
end
