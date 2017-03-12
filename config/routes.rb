Rails.application.routes.draw do

  get 'main_pages/home'

  devise_for :users, path_names: { sign_in: 'login', sign_out: 'logout' }, controllers: { registrations: 'registrations', omniauth_callbacks: 'omniauth_callbacks' }
  devise_scope :user do
    get "login", to: "devise/sessions#new"
    match '/users/:id/finish_signup' => 'registrations#finish_signup', via: [:get, :patch], :as => :finish_signup
  end
  resource :user do
    resources :addresses, only: [:create]
  end

  ActiveAdmin.routes(self)
  resources :products do
    get 'page/:page', action: :index, on: :collection
  end
  resource :product do
    resources :reviews
  end
  resources :orders, only: [:index, :show, :update]
  get 'cart', to: :cart, controller: 'orders'
  put 'update_cart', to: :update_cart, controller: 'orders'
  resource :checkouts, only: [:show, :update]
#  get 'checkout/address', to: 'orders#address'#, controller: 'orders'

#  resource :cart, only: [:show, :update]
  resources :order_items, only: [:create, :update, :destroy]
  get 'order_items', action: :create, controller: 'order_items'
  root 'main_pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
