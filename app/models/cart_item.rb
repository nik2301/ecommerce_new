class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product
  after_update :touch_products
  after_destroy :touch_products
  # default_scope { order(created_at: :desc) }

  private

  def touch_products
    product.update(updated_at: DateTime.now)
  end
end
