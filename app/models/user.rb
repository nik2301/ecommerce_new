class User < ApplicationRecord
  # include Devise::JWT::RevocationStrategies::JTIMatcher
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable,
         omniauth_providers: [:github, :google_oauth2]

        #  :jwt_authenticatable, jwt_revocation_strategy: self
  has_one :cart, dependent: :destroy
  has_many :cart_products, through: :cart, source: :products
  has_many :cart_items, through: :cart
  has_one :address, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :ordered_products, through: :orders, source: :products
  devise :timeoutable, :timeout_in => 1.day
  after_create :create_user_cart
  # def jwt_payload
  #   super
  # end

  def create_user_cart
    self.create_cart if self.persisted?
  end

  def self.from_omniauth(access_token, google = false, github = false)
    data = access_token.info
    user = User.where(email: data['email']).first
    # Uncomment the section below if you want users to be created if they don't exist
    unless user
      kind = google ? 'Google' : 'Github'
      user = User.create(
          email: data['email'],
          password: Devise.friendly_token[0,20]
      )
    end
    user
  end
end
