class CreateDevices < ActiveRecord::Migration[6.0]
  def change
    create_table :devices do |t|
      t.string :name
      t.string :mac
      t.string :ip
      t.boolean :active
      t.integer :type
      t.integer :state
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    # add_index :devices, :name, unique: true
  end
end
