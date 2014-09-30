NinetyNineCats::Application.routes.draw do
  resources :cats
  root to: "cats#index"
  resources :cat_rental_requests, only: [:new,:create,:edit,:update]
end
