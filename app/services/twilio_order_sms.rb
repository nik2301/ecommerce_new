class TwilioOrderSms
  require 'twilio-ruby'
  KEYS = YAML.load_file(File.join(Rails.root, 'app', 'assets', 'config', 'initializers', 'credentials.yml'))

  def initialize
    account_sid = KEYS["twilio"]["sid"]
    auth_token = KEYS["twilio"]["token"]
    @client = Twilio::REST::Client.new(account_sid, auth_token)
    @from = KEYS["twilio"]["num_from"] # Your Twilio number
    @to =  KEYS["twilio"]["num_to"] # Your mobile phone number
  end

  def send_sms(order)
    @client.messages.create(
      from: @from,
      to: @to,
      body: "Hello Admin..! A new Order No. #{order.id} has been placed successfully."
    )
    # Uncomment to activate voice calls
    # @client.calls.create(
    #   from: @from,
    #   to: @to,
    #   twiml: '<Response> <Say voice="alice">Hello Nikhil, How are you, have a n
    #   ice day. Thanks for trying our documentation. Enjoy!</Say> </Response>' )
  end

  def send_product_create_info(product)
    @client.messages.create(
      from: @from,
      to: @to,
      body: "Hello Admin, A new product (Name: #{product.name}, Description: #{product.description}, Price: #{product.price}) has been added successfully.!"
    )
  end
end