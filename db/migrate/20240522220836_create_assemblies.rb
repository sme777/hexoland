class CreateAssemblies < ActiveRecord::Migration[7.0]
  def change
    create_table :assemblies do |t|
      t.string :name
      t.string :author
      t.text :design_map

      t.timestamps
    end
  end
end
