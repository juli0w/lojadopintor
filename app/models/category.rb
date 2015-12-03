class Category < ActiveRecord::Base
  extend FriendlyId

  belongs_to :parent, class_name: "Category"
  has_many :children, class_name: "Category", foreign_key: "parent_id"
  has_many :products

  scope :actives, -> { where(active: true) }

  friendly_id :slug_name, use: :slugged

  def slug_name
    [
      :name,
      [:name, :id],
      [:name, :id, :alternative_id]
    ]
  end

  def self.import familias, grupos, subgrupos, itens
    return false if familias.blank? or grupos.blank? or subgrupos.blank? or itens.blank?
    return EfatorImportation.import(familias, grupos, subgrupos, itens)
  end

  def self.most_popular
    self.actives.sort_by {|e| e.products.size}.reverse.first(15)
  end

  def self.roots
    where(parent_id: nil)
  end

  def parent_name
    parent.try(:name)
  end

  def has_parent?
    parent.present?
  end

  def has_children?
    children.exists?
  end
end
