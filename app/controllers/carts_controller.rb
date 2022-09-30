class CartsController < ApplicationController
  before_action :authenticate_user!
  require "razorpay"

  def index
    @cart_items = current_user.cart.cart_items.eager_load(:product)
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
    # flash[:notice] = "Added successfully"

    params[:from_cart_page] == "true" ? (redirect_to cart_path) : (redirect_to products_path)
  end

  def deduct_from_cart
    cart_item = CartItem.find_by(product_id: params[:product_id], cart_id: params[:cart_id])
    cart_item.quantity -= 1
    cart_item.save
    # flash[:notice] = "Deleted successfully"

    params[:from_cart_page] == "true" ? (redirect_to cart_path) : (redirect_to products_path)
  end

  def remove_from_cart
    cart_item = current_user.cart.cart_items.find(params[:id])
    cart_item.destroy

    redirect_to cart_path
  end

  def bulk_delete_cart_items
    current_user.cart.cart_items.destroy_all
    redirect_to cart_path
  end

  def checkout
    @address = current_user.address ? current_user.address : current_user.address.new
    @cart_items = Cart.find(params[:cart_id]).cart_items.includes(:product)
  end

  def init_payment
    @order = RazorpayPayment.create_order(params[:total])
    @cart_items = CartItem.find(params[:ids].split)
  end

  def verify_payment
    confirm = RazorpayPayment.verify_payment(params)
    @cart_items = CartItem.find(params[:cart_items].split)

    if confirm
      create_order
      clear_cart
      redirect_to root_path, notice: "Hooray, your order has been successfully placed.!"
    else
      redirect_to root_path, alert: "Oops.. Something went wrong!"
    end
  end

  private

  def create_order
    order = current_user.orders.create(razorpay_payment_id: params[:razorpay_payment_id], razorpay_order_id: params[:razorpay_order_id])

    @cart_items.each do |item|
      order.order_items.create(product_id: item.product_id, quantity: item.quantity)
    end
  end

  def clear_cart
    CartItem.delete(params[:cart_items].split)
  end
end
