class AddOuiToMappings < ActiveRecord::Migration[6.0]
  def change
    add_column :mappings, :oui, :string
  end
end
