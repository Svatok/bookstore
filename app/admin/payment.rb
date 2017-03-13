ActiveAdmin.register Payment do

  permit_params :card_number, :name_on_card, :mm_yy, :cvv
  menu false



end
