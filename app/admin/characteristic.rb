ActiveAdmin.register Characteristic do

  permit_params :value

  menu false

  controller do
    def destroy
      super do
        redirect_back(fallback_location: root_path) and return
      end
    end
  end

end
