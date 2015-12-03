class Coupon < ActiveRecord::Base
  belongs_to :owner, class_name: "User"
  has_many :orders

  scope :actives, -> { where(active: true) }
  scope :not_expired, -> { where("expire_at IS null or expire_at > ?", DateTime.now) }

  TYPES = {
    "%" => 0,
    "R$" => 1
  }

  def self.by_code code
    where(name: code).first
  end

  def self.active? code
    c = Coupon.actives.not_expired.where(name: code)

    c.any?
  end

  def get_type
    Coupon::TYPES[(self.discount_type || 0)]
  end

  def get_value
    self.discount_type == 0 ? "#{self.value}%" : "R$ #{self.value}"
  end

  def owner_link
    self.owner || ""
  end

  def owner_name
    self.owner.try(:get_name) || ""
  end
end
