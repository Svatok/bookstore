ActiveAdmin.register User do

  permit_params :email, :password, :password_confirmation, role_ids: []

  index do
    column :email
    column :current_sign_in_at
    column :last_sign_in_at
    column :sign_in_count
    column :roles do |user|
      user.roles.first
    end
    actions
  end

  filter :email

  form do |f|
    f.inputs "User Details" do
        f.input :email
        f.input :password
        f.input :password_confirmation
        f.input :roles, as: :check_boxes
    end
    f.actions
  end

  controller do
    def update
      if params[:user][:password].blank?
        params[:user].delete "password"
        params[:user].delete "password_confirmation"
      end

      super
    end
  end
end
