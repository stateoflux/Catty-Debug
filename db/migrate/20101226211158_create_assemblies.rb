class CreateAssemblies < ActiveRecord::Migration
  def self.up
    create_table :assemblies do |t|
      t.string :project_name
      t.integer :revision

      t.timestamps
    end
  end

  def self.down
    drop_table :assemblies
  end
end
