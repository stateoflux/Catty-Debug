class AddAssemblyNumberToAssemblies < ActiveRecord::Migration
  def self.up
    add_column :assemblies, :assembly_number, :string
  end

  def self.down
    remove_column :assemblies, :assembly_number
  end
end
