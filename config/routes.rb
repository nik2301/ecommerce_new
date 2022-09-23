Rails.application.routes.draw do
  resources :products
  devise_for :users, :controllers => { :registrations => 'users/registrations' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'users#home'
  get 'add_to_cart' => 'products#add_to_cart'
end
