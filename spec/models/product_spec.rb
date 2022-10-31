require 'rails_helper'

RSpec.describe Product, type: :model do
  # user = User.first_or_create!(email: 'dean@example.com', password: 'password', password_confirmation: 'password')

  # Validations
  it 'has a name' do
    product = Product.new(
      name: '',
      description: 'qwertyuiopasdfghjklzxcvbnm',
      price: 12.34
    )
    expect(product).to_not be_valid

    product.name = "Test"
    expect(product).to be_valid
  end

  it 'has a description' do
    product = Product.new(
      name: "Test",
      description: "",
      price: 12.34
    )
    expect(product).to_not be_valid

    product.description = 'qwertyuiopasdfghjklzxcvbnm'
    expect(product).to be_valid
  end

  it 'has a price' do
    product = Product.new(
      name: "Test",
      description: 'qwertyuiopasdfghjklzxcvbnm',
      price: nil
    )
    expect(product).to_not be_valid

    product.price = 12.34
    expect(product).to be_valid
  end

  #Associations
  it "should have many cart items" do
    t = Product.reflect_on_association(:cart_items)
    expect(t.macro).to eq(:has_many)
  end

  # Callbacks
  # it 'triggers send_create_sms_to_admin on save' do
  #   product = Product.new(
  #     name: "Test",
  #     description: 'qwertyuiopasdfghjklzxcvbnm',
  #     price: 12.34
  #   )
  #   expect(product).to receive(:send_create_sms_to_admin)
  #   product.save
  # end
  # Commented because callback already covered when Product created

  # Scopes
  it 'include product with price > 30000 & exclude product with name length < 5' do
    product = Product.create(
      name: "Test",
      description: 'qwertyuiopasdfghjklzxcvbnm',
      price: 30001
    )
    expect(Product.price_above_30000).to include(product)
    expect(Product.with_long_name).to_not include(product)
  end

  it 'include product with name length > 5 & include product with price < 30000' do
    product = Product.create(
      name: "TestLength",
      description: 'qwertyuiopasdfghjklzxcvbnm',
      price: 20000
    )
    expect(Product.with_long_name).to include(product)
    expect(Product.price_above_30000).to_not include(product)
  end

  # Act as paranoid (Soft Delete Product)
  it 'does not destroy product really' do
    product = Product.create(
      name: "TestLength",
      description: 'qwertyuiopasdfghjklzxcvbnm',
      price: 20000
    )
    product.destroy
    expect(Product.only_deleted).to include(product)
  end

  # Has Image attached
  it 'has many attached images' do
    product = Product.new(
      name: "Test",
      description: 'qwertyuiopasdfghjklzxcvbnm',
      price: nil
    )
    product.images.attach(io: File.open(Rails.root.join('Witmates.jpeg')), filename: 'Witmates.jpeg', content_type: 'image/jpeg')
    expect(product.images).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end
