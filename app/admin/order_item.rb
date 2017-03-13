ActiveAdmin.register OrderItem do

  permit_params :unit_price, :quantity, :product_id, :order_id

  menu false


end
