class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items
  validates_presence_of :razorpay_payment_id, :razorpay_order_id

  enum status: { pending: 0, completed: 1, cancelled: 2 }
end
