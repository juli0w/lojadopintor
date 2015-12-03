class OrderStatus < ActiveRecord::Base
  has_many :orders

  def self.opened
    where(name: "Aberto").first
  end

  def self.confirmed
    where(name: "Confirmado").first
  end

  def self.paid
    where(name: "Pago").first
  end

  def self.sent
    where(name: "Enviado").first
  end

  def self.canceled
    where(name: "Cancelado").first
  end
end
