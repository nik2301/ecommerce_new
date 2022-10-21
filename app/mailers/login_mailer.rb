class LoginMailer < ApplicationMailer
  def login_mail
    email = params[:email]
    @password = params[:password]
    @kind = params[:kind]

    mail(to: email, subject: "Login successfull with #{@kind} ")
  end
end
