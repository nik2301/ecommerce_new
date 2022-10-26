class TwilioOrderSms
  require 'twilio-ruby'
  KEYS = YAML.load_file(File.join(Rails.root, 'app', 'assets', 'config', 'initializers', 'credentials.yml'))

  def self.send_sms(order)
    account_sid = KEYS["twilio"]["sid"]
    auth_token = KEYS["twilio"]["token"]
    client = Twilio::REST::Client.new(account_sid, auth_token)

    from = KEYS["twilio"]["num_from"] # Your Twilio number
    to =  KEYS["twilio"]["num_to"] # Your mobile phone number

    client.messages.create(
      from: from,
      to: to,
      body: "Hello Admin..! A new Order No. #{order.id} has been placed successfully."
    )
  end
end