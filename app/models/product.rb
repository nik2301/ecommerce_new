class Product < ApplicationRecord
  has_many :cart_items, dependent: :destroy
  scope :price_above_30000, -> { where("price > 30000") }
  scope :with_long_name, -> { where("LENGTH(name) > 5") }
  has_many_attached :images, dependent: :destroy
end
