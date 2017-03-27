Rails.application.routes.draw do

  devise_for :users, path: '/', only: :omniauth_callbacks,
                    controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  scope '(:locale)', locale: /en/ do

    get 'main_pages/home'

    devise_for :users, path_names: { sign_in: 'login', sign_out: 'logout' }, skip: :omniauth_callbacks,
                        controllers: { registrations: 'registrations' }
    devise_scope :user do
      get 'login', to: 'devise/sessions#new'
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

    resource :cart, only: [:show, :update]
    resources :orders, only: [:index, :show, :update]
    resource :checkouts, only: [:show, :update]

    get '/:locale' => 'main_pages#home'
    root 'main_pages#home'
  end
end
