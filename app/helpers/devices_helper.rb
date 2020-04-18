module DevicesHelper

    ##
    # View helpers
    ##

    def device_icons
        {
            :generic => 'plug',
            :desktop => 'desktop',
            :laptop => 'laptop',
            :server => 'server',
            :printer => 'print'
        }
    end

    def device_icon(icon, options={})
        return fa_icon(device_icons[icon.to_sym], options)
    end

    def device_status(device)
        if device.active == false
            "DISABLED"
        else
            "POLLING"
        end
    end
    
end
