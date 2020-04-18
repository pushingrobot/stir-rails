# require 'arp_scan'
# require 'resolv'

class Mapping < ApplicationRecord

  scope :current, ->(time = 1.week.ago) { where("updated_at > ?", time) }
  scope :sorted, ->() { order(:ip => :asc, :updated_at => :desc) }
  scope :query, ->(q) { where("identifier LIKE ?", "%#{sanitize_sql_like(q)}%") }

  def self.known_hosts(freshen: false)
    self.refresh if freshen
    self.current.sorted.pluck_all(:identifier, :host, :mac, :oui, :updated_at)
  end

  def self.refresh
    current_hosts = merge_hostnames( scan_hosts() )

    Mapping.upsert_all(
      current_hosts,
      :unique_by => :identifier,
      :returning => false
    );
  end

  protected

    def self.scan_hosts
      ARPScan('--localnet --ignoredups').hosts
    end
  
    def self.merge_hostnames(hosts = [])
      mappings = []
      hosts.each do |host|
        mappings.concat(
          Resolv.getnames(host.ip_addr)
                .push(host.ip_addr)
                .map do |hostname|
            {
              identifier: "#{hostname},#{host.mac}",
              host: hostname,
              ip: host.ip_addr,
              mac: host.mac,
              oui: host.oui,
              source: 'scan',
              created_at: Time.now,
              updated_at: Time.now
            }
          end
        )
      end
      return mappings
    end
end

# because arp uses the broadcast address,
# two hosts could potentially respond with the same IP address
# but different MAC addresses. This would be an IP conflict.
# likewise, a single MAC could have multiple IPs and respond from
# each of them.
# and, a single IP could have multiple DNS entries, or multiple IPs
# could share a single IP.

# sort by age

# clear out stuff older than a day
# if a new mapping uses the same host or mac

# forget complicated relationships, just say
# "this MAC may be associated with this IP or hostname"
# and let the user figure it out