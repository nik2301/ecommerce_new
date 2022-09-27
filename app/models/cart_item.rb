class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product
  # default_scope { order(created_at: :desc) }
end
