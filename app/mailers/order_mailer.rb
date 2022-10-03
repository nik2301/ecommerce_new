class OrderMailer < ApplicationMailer
  def new_order_email
    @order = params[:order]
    @user = params[:user]

    mail(to: "admin@example.com", subject: "You got a new order..!")
  end
end
