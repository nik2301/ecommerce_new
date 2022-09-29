class RazorpayPayment
  require "razorpay"
  require 'yaml'
  RAZOR = YAML.load_file(File.join(Rails.root, 'app/assets/config/initializers', 'credentials.yml'))

  def self.create_order(amount)
    # Razorpay.setup('YOUR_KEY_ID', 'YOUR_SECRET')
    Razorpay.setup(RAZOR["razor"]["key"], RAZOR["razor"]["secret"])

    Razorpay::Order.create amount: amount, currency: 'INR', receipt: 'TEST'
  end

  def self.verify_payment(response)
    payment_response = {
      :razorpay_order_id   => response[:razorpay_order_id],
      :razorpay_payment_id => response[:razorpay_payment_id],
      :razorpay_signature  => response[:razorpay_signature]
    }
    Razorpay::Utility.verify_payment_signature(payment_response)
  end
end