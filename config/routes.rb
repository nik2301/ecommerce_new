Rails.application.routes.draw do
  resources :products
  devise_for :users, :controllers => { :registrations => 'users/registrations' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'users#home'
  get 'cart' => 'carts#index'
  get 'add_to_cart' => 'carts#add_to_cart'
  get 'deduct_from_cart' => 'carts#deduct_from_cart'
  delete 'remove_from_cart' => 'carts#remove_from_cart'
  get 'bulk_delete_cart_items' => 'carts#bulk_delete_cart_items'
end
