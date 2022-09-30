class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one :cart, dependent: :destroy
  has_many :cart_products, through: :cart, source: :products
  has_many :cart_items, through: :cart
  has_one :address, dependent: :destroy
  has_many :orders
  has_many :ordered_products, through: :orders, source: :products
  devise :timeoutable, :timeout_in => 1.day
end
