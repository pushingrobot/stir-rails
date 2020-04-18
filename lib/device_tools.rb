require 'net/ping'
require 'resolv'
# require 'arp_scan'

##
# Address lookup
##

class DeviceTools

  def self.stir(mac)
    system("wakeonlan #{mac}")
  end
  
  def self.poll(devices=[])
    return [] if devices.blank?
    host_list = devices.map(&:host).join(' ')
    active_hosts = ARPScan("--ignoredups #{host_list}").hosts.group_by(&:mac)

    devices.map{ |d| Rails.logger.debug(d.mac); {id: d.id, ready: active_hosts.has_key?(d.mac) } }
    # Net::Ping::External.new(host).ping?
  end

  # def self.lookup(input)
  #   host = sanitize_host(input)
  #   case
  #   when host[:ip]
  #     hostnames = Resolv.get_names(host[:ip])
  #     macs = ip_to_mac(host[:ip])
  #   when host[:mac]
  #     ips = mac_to_ips
  #     hostnames = ips.map{|ip| Resolv.get_names(ip)}.flatten
  #   when host[:hostname]
  #     ips = Resolv.get_addresses(host[:hostname])
  #     macs = ips.map{|ip| ip_to_macs(ip) }.flatten
  #   else
  #     return []
  #   end
  #   # TODO: finish this
  #   return []
  # end

  # def self.ip_to_macs(ip)
  #   @arp_scan ||= ARPScan('--localnet').hosts # cache?
  #   @arp_scan.filter {|h| h.ip_addr == ip}
  #            .map{|h| {ip: h.ip_addr, mac: h.mac} }
  # end

  # def self.mac_to_ips(mac)
  #   @arp_scan ||= ARPScan('--localnet').hosts # cache?
  #   @arp_scan.filter {|h| h.mac == mac}
  #            .map{|h| {ip: h.ip_addr, mac: h.mac} }
  # end

  # def self.sanitize_host(input)
  #   host = input.to_s.strip
  #   case
  #   when host.length == 0
  #     {error: :no_input}
  #   when valid_ip?(host)
  #     {ip: host}
  #   when valid_mac?(host)
  #     {mac: host}
  #   when valid_hostname?(host)
  #     {hostname: host}
  #   else
  #     {error: :invalid_input}
  #   end
  # end

  def self.valid_mac?(mac)
    mac.match? /\A([0-9A-F][0-9A-F]:){5}([0-9A-F][0-9A-F])\z/i
  end

  def self.valid_ip?(ip)
    ip.match? Regexp.union([Resolv::IPv4::Regex, Resolv::IPv6::Regex])
  end

  ## Source: https://dzone.com/articles/simple-hostname-validation
  def self.valid_hostname?(hostname)
    return false if hostname.length > 255 or hostname.scan('..').any?
    hostname = hostname[0 ... -1] if hostname.index('.', -1)
    return hostname.split('.').collect { |i|
    i.size <= 63 and not (i.rindex('-', 0) or i.index('-', -1) or i.scan(/[^a-z\d-]/i).any?)
    }.all?
  end

  # def test(hosts = [])


  # end

  # def self.known_hosts
  #   Rails.cache.fetch("known_hosts", expires_in: 30.seconds) do
  #     Rails.logger.debug "<<< Refreshing hosts cache >>>"
  #     grouped_hosts = []
  #     ARPScan('--localnet').hosts.group_by(&:ip_addr).each do |ip, hosts|
  #       grouped_hosts.push({
  #         text: ip,
  #         children: hosts.Resolv.getnames(host.ip_addr).push(host.ip_addr).map{|hostname|
  #           {
  #             ip: "#{hostname},#{host.mac}",
  #             mac: host.mac,
  #             text: id,
  #             oui: host.oui
  #           }
  #         }
  #       })
  #     end
  #     grouped_hosts
  #   end
  # end

end

  #   # ping host to add it to ARP cache
  #   `ping -c 2 -i 0.25 #{host}`
  #   # get MAC from ARP cache
  #   @mac = `arp -a #{host}`&.match(ip_pattern)&.[](1)

  # def self.lookup_host(mac)
  #     ip = ARPScan('--localnet').find |host| host.mac == @mac}&.ip_addr
  #     return ip && ( Resolv.getname(ip) || ip )
  #   end