class CartsController < ApplicationController
  def index
    @cart_items = current_user.cart.cart_items.includes(:product)
  end
end
