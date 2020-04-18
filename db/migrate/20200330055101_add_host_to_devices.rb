class AddHostToDevices < ActiveRecord::Migration[6.0]
  def change
    add_column :devices, :host, :string
  end
end
