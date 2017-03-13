ActiveAdmin.register Price do

  permit_params :product_id, :value, :date_start

  menu false



end
