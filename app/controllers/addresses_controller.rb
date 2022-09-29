class AddressesController < ApplicationController
  def create
    @address = current_user.address.new(address_params)
    if @address.save
      redirect_to cart_path
    else
      render 'checkout'
    end
  end

  def update
    if current_user.address.update(address_params)
      redirect_to checkout_path(cart_id: current_user.cart.id), notice: "Address changed.."
    else
      redirect_to checkout_path(cart_id: current_user.cart.id), alert: "Address can't be blank"
    end
  end

  private
  def address_params
    params.require(:address).permit(:content)
  end
end
