ActiveAdmin.register Address do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :content, :user_id
  #
  # or
  #
  # permit_params do
  #   permitted = [:content, :user_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  filter :user_email, as: :select, collection: User.all.pluck(:email)
  filter :created_at
  filter :updated_at
end
