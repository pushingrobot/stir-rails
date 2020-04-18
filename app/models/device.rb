class Device < ApplicationRecord

  belongs_to :user

  enum icon: [ :generic, :desktop, :laptop, :server, :printer ]

  scope :active, ->() { where(:active => true) }

  validates :name, presence: true
  validates :user, presence: true
  validates :active, inclusion: { in: [true, false] }
  validates :icon, presence: true, inclusion: { in: icons.keys }
  validates :host, presence: { message: "can't be blank if the device is active." }, if: :active
  validate  :host, :validate_host, if: :active
  validates :mac, presence: { message: "can't be blank if the device is active." }, if: :active
  validate  :mac, :validate_mac, if: :active

  after_initialize :set_defaults, if: :new_record?

  def set_defaults
    self.icon ||= :generic
  end

  def validate_host
    return if errors.include?(:host) ||
              DeviceTools.valid_ip?(self.host) ||
              DeviceTools.valid_hostname?(self.host)
    errors.add(:host, "is an invalid IP address or hostname")
  end

  def validate_mac
    return if errors.include?(:mac) ||
              DeviceTools.valid_mac?(self.mac)
    errors.add(:mac, "is an invalid MAC address")
  end

  def stir
    DeviceTools.stir(self.mac)
  end

  def poll
    DeviceTools.poll([self])
  end

  def mac=(new_mac)
    super(new_mac.downcase)
  end

  def mac
    super&.downcase
  end
end
