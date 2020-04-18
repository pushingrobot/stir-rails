class User < ApplicationRecord
  has_secure_password
  has_many :devices, inverse_of: :user, :dependent => :destroy
  accepts_nested_attributes_for :devices,
    allow_destroy: true,
    reject_if: :all_blank

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :admin, inclusion: { in: [true, false] }

  after_initialize :set_defaults, if: :new_record?

  def set_defaults
    self.admin ||= false
  end
end
