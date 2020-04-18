class ChangeDeviceTypeToIcon < ActiveRecord::Migration[6.0]
  def change
    rename_column :devices, :type, :icon
  end
end
