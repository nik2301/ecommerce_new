class ProductsController < ApplicationController
  require 'csv'
  before_action :set_product, only: %i[ show edit update destroy ]

  # GET /products or /products.json
  def index
    @products = Product.all
    respond_to do |format|
      format.json { render :index, location: @product }
      format.html
    end
  end

  # GET /products/1 or /products/1.json
  def show
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
    headers = %w[ Name Description Price ]
    file =  CSV.open("products.csv", "w") do |csv|
              csv = @products.map do |product|
                      CSV.generate_line([
                                          product.try(:name),
                                          product.try(:description),
                                          product.try(:price)
                                        ])
                    end
              csv.unshift(CSV.generate_line(headers))
            end

    ProductMailer.with(email: current_user.email, csv: file).mail_csv.deliver_later
    redirect_to products_path, notice: "Email sent on your registered Mail ID"
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
