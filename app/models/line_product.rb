class LineProduct < ActiveRecord::Base
  has_many :products

  def self.seed
    LineProduct.delete_all
    LineProduct.create(id: 1, name: "Recomendado")
    LineProduct.create(id: 2, name: "Mais vendidos")
    LineProduct.create(id: 3, name: "Novidades")
  end

  def self.stars
    where(name: "Recomendado").first.products
  end

  def self.sellers
    where(name: "Mais vendidos").first.products
  end

  def self.news
    where(name: "Novidades").first.products
  end
end
