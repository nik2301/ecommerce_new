class AddressesController < ApplicationController
  def checkout

    @address = current_user.address ? current_user.address : current_user.address.new
  end

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
      redirect_to cart_path
    else
      render 'checkout'
    end
  end

  private
  def address_params
    params.require(:address).permit(:content)
  end
end
