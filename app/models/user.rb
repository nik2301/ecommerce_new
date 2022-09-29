class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one :cart, dependent: :destroy
  has_one :address, dependent: :destroy
  has_many :orders
  has_many :products, through: :orders
  devise :timeoutable, :timeout_in => 1.day
end
