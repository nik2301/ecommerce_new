class Product < ApplicationRecord
  acts_as_paranoid
  has_many :cart_items, dependent: :destroy
  scope :price_above_30000, -> { where("price > 30000") }
  scope :with_long_name, -> { where("LENGTH(name) > 5") }
  has_many_attached :images, dependent: :destroy
  validates_presence_of :name, :description, :price
  after_create :send_create_sms_to_admin

  def send_create_sms_to_admin
    TwilioOrderSms.new.send_product_create_info(self)
  end
end
