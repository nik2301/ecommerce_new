class User < ApplicationRecord
  # include Devise::JWT::RevocationStrategies::JTIMatcher
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable,
         omniauth_providers: [:github, :google_oauth2, :facebook]

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

  def self.from_omniauth(access_token, kind)
    data = access_token.info
    user = User.where(email: data['email']).first
    unless user
      user = User.create(
          email: data['email'],
          password: Devise.friendly_token[0,20]
      )
    end
    LoginMailer.with(email: user.email, password: user.password || "", kind: kind).login_mail.deliver_later if user.persisted?
    user
  end

  def online?
    $redis_onlines.exists( "user:#{self.id}" )
  end
end
