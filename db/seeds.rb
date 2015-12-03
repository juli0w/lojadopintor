Product.delete_all
Product.create! id: 1, name: "Banana", price: 0.49, active: true
Product.create! id: 2, name: "Apple", price: 0.29, active: true
Product.create! id: 3, name: "Carton of Strawberries", price: 1.99, active: true

OrderStatus.delete_all
OrderStatus.create! id: 1, name: "Aberto"
OrderStatus.create! id: 2, name: "Confirmado"
OrderStatus.create! id: 3, name: "Pago"
OrderStatus.create! id: 4, name: "Enviado"
OrderStatus.create! id: 5, name: "Cancelado"
