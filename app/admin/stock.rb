ActiveAdmin.register Stock do

  permit_params :product_id, :value, :date_start

  menu false

end
