class ReviewsController < ApplicationController
  before_action :set_review, only: %i[ like unlike ]
  before_action :authenticate_user!

  def create
    product = Product.find(params[:product_id])
    review = product.reviews.create(user_id: current_user.id, content: params[:review][:content])
    if review.persisted?
      redirect_to product, notice: "Review Added Successfully.."
    else
      redirect_to product, alert: "#{review.errors.full_messages.join(', ')}"
    end
  end

  def like
    @review.likes.create(user_id: current_user.id)
    redirect_to product_path(params[:product_id])
  end

  def unlike
    review = @review.likes.where(user_id: current_user.id)
    review.destroy_all
    redirect_to product_path(params[:product_id])
  end

  def set_review
    @review = Review.find(params[:review_id])
  end
end
