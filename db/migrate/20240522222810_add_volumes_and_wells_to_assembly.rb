class AddVolumesAndWellsToAssembly < ActiveRecord::Migration[7.0]
  def change
    add_column :assemblies, :volumes, :text
    add_column :assemblies, :wells, :text
  end
end
