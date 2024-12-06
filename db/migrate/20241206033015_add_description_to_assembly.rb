class AddDescriptionToAssembly < ActiveRecord::Migration[7.0]
  def change
    add_column :assemblies, :description, :string
  end
end
