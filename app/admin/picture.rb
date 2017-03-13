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


end
