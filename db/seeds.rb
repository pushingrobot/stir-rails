require 'csv'

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

#
# This will automatically import CSV files to fill the database.
# The files should have headers and include the following columns:
# 
# users.csv:
#   name,
#   email,
#   password,
#   admin (true/false)
#
# devices.csv:
#   email, (for associating the device with a user)
#   name, (friendly name for device)
#   icon, (can be generic, desktop, laptop, server, or printer)
#   host, (IPv4 address or DNS hostname)
#   mac, (MAC address in xx:yy:zz format)
#   active (true/false; inactive devices will be hidden from non-admin users)

USERS_FILE = 'import/users.csv'
DEVICES_FILE = 'import/devices.csv'

bad_users = {}
invalid_devices = {}
bad_devices = {}

if File.exists?(USERS_FILE)
    CSV.foreach(USERS_FILE, :headers => true) do |user|
        user = User.new({
            name: user['name'],
            email: user['email'],
            password: user['password'],
            admin: (user['admin'] == 'true')
        })
        if !user.save
            bad_users[user.email || user.name] = user.errors.full_messages
        end
    end


    if File.exists?(DEVICES_FILE)
        CSV.foreach(DEVICES_FILE, :headers => true) do |device|
            dev = Device.new({
                user: User.find_by(:email => device['email']),
                name: device['name'],
                icon: device['icon'],
                host: device['host'],
                mac: device['mac'],
                active: device['active'] != 'false'
            })
            if !dev.save
                dev.active = false
                if dev.save
                    invalid_devices[dev.name || dev.host] = dev.errors.full_messages
                else
                    bad_devices[dev.name || dev.host] = dev.errors.full_messages
                end
            end
        end
    else
        p "#{DEVICES_FILE} not found. Please check the name and path."
    end

    p "Import complete."

    unless bad_users.empty?
        p "#{bad_users.length} users could not be imported:"
        bad_users.each{ |user, errors| p "#{user}: #{errors.join', '}" }
    end

    unless invalid_devices.empty?
        p "#{invalid_devices.length} devices had invalid configuration:"
        invalid_devices.each{ |device, errors| p "#{device}: #{errors.join', '}" }
    end

    unless bad_devices.empty?
        p "#{bad_devices.length} devices could not be imported:"
        bad_devices.each{ |device, errors| p "#{device}: #{errors.join', '}" }
    end

else
    p "#{USERS_FILE} not found. Please check the name and path."
end


    
unless User.exists?(:admin => true)
    User.create(
        name: 'David',
        email: 'dstephens@nelsonengineering.net',
        admin: true,
        password: 'password'
    )
end