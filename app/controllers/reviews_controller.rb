class ReviewsController < ApplicationController
  def create
    product = Product.find(params[:product_id])
    review = product.reviews.create(user_id: current_user.id, content: params[:review][:content])
    if review.persisted?
      redirect_to product, notice: "Review Added Successfully.."
    else
      redirect_to product, alert: "#{review.errors.full_messages.join(', ')}"
    end
  end
end
