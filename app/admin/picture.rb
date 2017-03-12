ActiveAdmin.register Picture do

  permit_params :image_path, :imageable_id, :imageable_type

  menu false


  controller do
    def destroy
      super do
        redirect_back(fallback_location: root_path) and return
      end
    end
  end

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end


end
