class ProductsController < ApplicationController
  require 'csv'
  before_action :set_product, only: %i[ show edit update destroy ]

  # GET /products or /products.json
  def index
    @products = Product.all
    respond_to do |format|
      format.json { render :index, location: @product }
      format.html
      format.pdf do
        # Rails 5,6
        render template: "products/index.html.erb",
               pdf: "Products: #{@products.count}",
               layout: 'pdf.html'

        # Rails 7
        # https://github.com/mileszs/wicked_pdf/issues/1005
        # render pdf: "Posts: #{@posts.count}", # filename
        #        template: "hello/print_pdf",
        #        formats: [:html],
        #        disposition: :inline,
        #        layout: 'pdf'
      end
    end
  end

  # GET /products/1 or /products/1.json
  def show
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "Product: #{@product.name}",
               template: "pdf/product_details.html.erb",
               layout: "pdf.html"
      end
    end
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products or /products.json
  def create
    @product = Product.new(product_params)
    @product.images.attach(params[:product][:images]) if params[:product][:images].present?

    respond_to do |format|
      if @product.save
        format.html { redirect_to product_url(@product), notice: "Product was successfully created." }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1 or /products/1.json
  def update
    @product.images.attach(params[:product][:images]) if params[:product][:images].present?
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to product_url(@product), notice: "Product was successfully updated." }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1 or /products/1.json
  def destroy
    @product.destroy

    respond_to do |format|
      format.html { redirect_to products_url, notice: "Product was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def export_csv
    @products = Product.all

    respond_to do |format|
      format.csv do
        response.headers['Content-Type'] = 'text/csv'
        response.headers['Content-Disposition'] = "attachment; filename=products.csv"
        render template: "products/export.csv.erb"
      end
    end
  end

  def email_csv_to_user
    authenticate_user!
    @products = Product.all
    Product.generate_csv(current_user, @products)

    redirect_to products_path, notice: "Email sent on your registered Mail ID"
  end

  def upload_csv
    result = Product.convert_file(params)

    if result.is_a?(Array)
      redirect_to products_path, alert: "Error: #{result[1].join} on line number #{result[0]} "
      return
    end
    redirect_to products_path, notice: "File Uploaded Successfully"
  end

  def send_pdf_as_email
    authenticate_user!
    product = Product.find(params[:id])

    ProductMailer.with(email: current_user.email).mail_pdf(product).deliver_later
    redirect_to product_path(product), notice: "PDF sent on your registered mail"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def product_params
      params.require(:product).permit(:name, :description, :price)
    end
end
