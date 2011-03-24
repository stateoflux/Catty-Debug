class AddProperNameToAssemblies < ActiveRecord::Migration
  def self.up
    add_column :assemblies, :proper_name, :string
  end

  def self.down
    remove_column :assemblies, :proper_name
  end
end
