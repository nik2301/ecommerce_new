class ProductMailer < ApplicationMailer
  def mail_csv
    body = "You can download the file attached with this mail."
    attachments['products.csv'] = {mime_type: 'text/csv', content: params[:csv]}
    mail(to: params[:email], subject: 'CSV for All Products', body: body)
  end

  def mail_pdf(product)
    @product = product
    body = "You can download the PDF file attached with this mail."
    attachments["product_#{@product.name}.pdf"] = WickedPdf.new.pdf_from_string(
      render_to_string(template: 'pdf/product_details.html.erb', layout: 'pdf.html', pdf: "Product: #{@product.name}")
    )
    mail(to: params[:email], subject: 'Here is your PDF', body: body)
  end
end
