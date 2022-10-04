ActiveAdmin.register Order do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :status, :razorpay_payment_id, :razorpay_order_id, :user_id
  #
  # or
  #
  # permit_params do
  #   permitted = [:status, :razorpay_payment_id, :razorpay_order_id, :user_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  filter :products
  filter :status, as: :select
  filter :razorpay_payment_id
  filter :razorpay_order_id
  filter :user_email, as: :select, collection: User.all.pluck(:email)
  filter :created_at
  filter :updated_at

  action_item :pending, only: :show do
    link_to "Pending", pending_status_admin_order_path(order), method: :put
  end

  action_item :complete, only: :show  do
    link_to "Complete", complete_status_admin_order_path(order), method: :put
  end

  action_item :cancel, only: :show do
    link_to "Cancel", cancel_status_admin_order_path(order), method: :put
  end

  member_action :pending_status, method: :put do
    @order = Order.find(params[:id])
    @order.pending!
    redirect_to admin_order_path(@order)
  end

  member_action :complete_status, method: :put do
    @order = Order.find(params[:id])
    @order.completed!
    redirect_to admin_order_path(@order)
  end

  member_action :cancel_status, method: :put do
    @order = Order.find(params[:id])
    @order.cancelled!
    redirect_to admin_order_path(@order)
  end
end
