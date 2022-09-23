class CartsController < ApplicationController
  def index
    @cart_items = current_user.cart.cart_items.includes(:product)
  end

  def add_to_cart
    # if current_user.cart.products.ids.include? params[:product_id].to_i
    #   cart_item = CartItem.find(params[:cart_id])
    #   cart_item.quantity += 1
    #   cart_item.save
    # else
    #   CartItem.create(cart_id: params[:cart_id], product_id: params[:product_id])
    # end
    cart_item = CartItem.find_or_create_by(product_id: params[:product_id], cart_id: params[:cart_id])
    cart_item.quantity += 1
    cart_item.save
    flash[:notice] = "Added successfully"

    params[:from_cart_page] == "true" ? (redirect_to cart_path) : (redirect_to products_path)
  end

  def deduct_from_cart
    cart_item = CartItem.find_by(product_id: params[:product_id], cart_id: params[:cart_id])
    cart_item.quantity -= 1
    cart_item.save
    flash[:notice] = "Deleted successfully"

    params[:from_cart_page] == "true" ? (redirect_to cart_path) : (redirect_to products_path)
  end

  def remove_from_cart
    cart_item = current_user.cart.cart_items.find(params[:id])
    cart_item.destroy

    redirect_to cart_path
  end

  def bulk_delete_cart_items
    binding.pry
    current_user.cart.cart_items.destroy_all
    redirect_to cart_path
  end
end
