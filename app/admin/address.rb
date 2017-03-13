ActiveAdmin.register Address do

  permit_params :first_name, :last_name, :address, :city, :zip, :phone, :address_type

  menu false

end
