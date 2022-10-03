module OrderTotal
  extend ActiveSupport::Concern

  def total_amount(order_items)
    order_items.map{|item| item.quantity * item.product.price}.sum.to_i
  end
end