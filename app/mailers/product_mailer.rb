class ProductMailer < ApplicationMailer
  def mail_csv
    body = "You can download the file attached with this mail."
    attachments['products.csv'] = {mime_type: 'text/csv', content: params[:csv]}
    mail(to: params[:email], subject: 'CSV for All Products', body: body)
  end
end
