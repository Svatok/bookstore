ActiveAdmin.register Category, as: "Product Categories" do

  permit_params :name, :default_sort

end
