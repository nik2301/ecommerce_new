class OrderMailer < ApplicationMailer
  add_template_helper(CartsHelper)

  def new_order_email
    @order = params[:order]
    @user = params[:user]

    mail(to: "admin@example.com", subject: "You got a new order..!")
  end

  def order_created_mail
    @order = params[:order]
    @user = params[:user]

    mail(to: @user.email, subject: "Hooray.! Your Order is Confirmed")
  end
end
