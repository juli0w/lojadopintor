class Product < ActiveRecord::Base
  extend FriendlyId

  acts_as_taggable
  mount_uploader :image, ImageUploader
  has_many :order_items
  belongs_to :category
  belongs_to :line_product

  scope :purchables, -> { where("weight > 0 and width > 0 and depth > 0 and height > 0 and active = ?", true) }

  friendly_id :slug_name, use: :slugged

  def slug_name
    [
      :name,
      [:name, :id],
      [:name, :id, :alternative_id]
    ]
  end

  def purchable?
    has_shipping_infos? and active? and category.try(:active?)
  end

  def has_shipping_infos?
    (self.weight > 0) and (self.width > 0) and (self.depth > 0) and (self.height > 0)
  end

  def cost
    price + calculate_tax
  end

  def calculate_tax
    price * ((tax.to_f || 0) / 100)
  end
end
