module CartsHelper
  def filter_cart_items(cart_items)
    cart_items.filter {|item| item.quantity > 0}
  end

  def total_amount(cart_items)
    cart_items.map{|item| item.product.price}.sum.to_i
  end
end
