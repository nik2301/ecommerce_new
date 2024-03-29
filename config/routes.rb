Rails.application.routes.draw do
  get 'movies/index'
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  resources :orders
  resources :addresses
  resources :products do
    get 'export' => 'products#export_csv', on: :collection
    get 'like' => 'products#like'
    get 'unlike' => 'products#unlike'
    resources :reviews do
      get 'like' => 'reviews#like', on: :collection
      get 'unlike' => 'reviews#unlike', on: :collection
    end
  end
  devise_for :users, :controllers => {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    omniauth_callbacks: 'users/omniauth_callbacks' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'users#home'
  get 'cart' => 'carts#index'
  get 'add_to_cart' => 'carts#add_to_cart'
  get 'deduct_from_cart' => 'carts#deduct_from_cart'
  delete 'remove_from_cart' => 'carts#remove_from_cart'
  get 'bulk_delete_cart_items' => 'carts#bulk_delete_cart_items'
  get 'checkout' => 'carts#checkout'
  get 'init_payment' => 'carts#init_payment'
  post 'verify_payment' => 'carts#verify_payment'
  get 'email_csv' => 'products#email_csv_to_user'
  post 'upload' => 'products#upload_csv'
  get 'email_pdf' => 'products#send_pdf_as_email'
  get 'movies' => 'movies#index'
  get 'movies/:id' => 'movies#movie_detail'
end
