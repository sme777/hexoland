class AddAssemblyMapToAssembly < ActiveRecord::Migration[7.0]
  def change
    add_column :assemblies, :assembly_map, :jsonb, default: {}, null: false
  end
end
