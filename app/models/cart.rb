class Cart < ApplicationRecord
  belongs_to :user
  # has_many :cart_items, -> { order(product_id: :desc) }
  # has_many :cart_items, -> { order(created_at: :desc) }
  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items
end
