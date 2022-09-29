class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.integer :status, default: 0
      t.string :razorpay_payment_id
      t.string :razorpay_order_id
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
