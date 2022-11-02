class Product < ApplicationRecord
  include Reviewable
  include Likable
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

  def self.generate_csv(user, products)
    headers = %w[ Name Description Price ]
    file =  CSV.open("products.csv", "w") do |csv|
              csv = products.map do |product|
                      CSV.generate_line([
                                          product.try(:name),
                                          product.try(:description),
                                          product.try(:price)
                                        ])
                    end
              csv.unshift(CSV.generate_line(headers))
            end

    ProductMailer.with(email: user.email, csv: file).mail_csv.deliver_later
  end

  def self.convert_file(params)
    csv_text = File.read(params[:attachment].path)
    converter = lambda { |header| header.downcase }
    csv = CSV.parse(csv_text, headers: true, header_converters: converter)
    create_products_from_uploaded_file(csv)
  end

  def self.create_products_from_uploaded_file(csv)
    ActiveRecord::Base.transaction do
      csv.each_with_index do |row, i|
        product = Product.create(row.to_hash)
        if product.errors.any?
          return [i+2, product.errors.full_messages, product.name]
        end
      end
    end
  end

  def self.send_to_user(email, product)
    ProductMailer.with(email: email).mail_pdf(product).deliver_later
  end

  def self.generate_qr_code(product)
    qr = RQRCode::QRCode.new(product.to_json(except: [:created_at, :updated_at]))
    svg = qr.as_svg(
      offset: 0,
      color: 'FF0000',
      shape_rendering: 'crispEdges',
      module_size: 2
    )
  end
end
