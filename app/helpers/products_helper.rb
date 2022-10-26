module ProductsHelper
  def find_cart_item(product)
    current_user.cart_items.find_by_product_id(product)
  end

  def current_cart
    current_user&.cart&.id
  end
end
