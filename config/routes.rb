NinetyNineCats::Application.routes.draw do
  resources :cats
  root to: "cats#index"
  resources :cat_rental_requests, only: [:new,:create,:edit,:update]
  post 'approve_rental/:id', to: 'cat_rental_requests#approve', as: 'approve'
  post 'deny_rental/:id', to: 'cat_rental_requests#deny', as: 'deny'
  resources :users, only: [:new, :create]
  resource :session, only: [:new, :destroy, :create]
end
