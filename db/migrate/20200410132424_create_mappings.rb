class CreateMappings < ActiveRecord::Migration[6.0]
  def change
    create_table :mappings do |t|
      t.string :identifier
      t.string :host
      t.string :ip
      t.string :mac
      t.string :source

      t.timestamps
    end
    add_index :mappings, :identifier, unique: true
  end
end
