Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  
  # Defines the root path route ("/")
  root "allergens#index"
  resources :products
  resources :allergens
end
