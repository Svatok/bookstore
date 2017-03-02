Rails.application.routes.draw do
  get 'main_pages/home'

  devise_for :users, path_names: { sign_in: 'login', sign_out: 'logout' }, controllers: { registrations: 'registrations' }
  devise_scope :user do
    get "login", to: "devise/sessions#new"
  end
  resource :user do
    resources :addresses
  end
  ActiveAdmin.routes(self)
  resources :products do
    get 'page/:page', action: :index, on: :collection
  end
  resource :product do
    resources :reviews
  end
#  resources :addresses
  root 'main_pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
