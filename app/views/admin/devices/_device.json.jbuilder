json.extract! device, :id, :name, :mac, :active, :type, :state, :user_id, :created_at, :updated_at
json.url device_url(device, format: :json)
