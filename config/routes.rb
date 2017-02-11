Rails.application.routes.draw do
  get 'main_pages/home'

  devise_for :users, path_names: { sign_in: 'login', sign_out: 'logout' }
  devise_scope :user do
    get "login", to: "devise/sessions#new"
  end
  ActiveAdmin.routes(self)

  root 'main_pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
