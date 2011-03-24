class AddNumOfR2d2sToAssemblies < ActiveRecord::Migration
  def self.up
    add_column :assemblies, :num_of_r2d2s, :integer
  end

  def self.down
    remove_column :assemblies, :num_of_r2d2s
  end
end
