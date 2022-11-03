ActiveAdmin.register User do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :email, :encrypted_password, :reset_password_token, :reset_password_sent_at, :remember_created_at
  #
  # or
  #
  # permit_params do
  #   permitted = [:email, :encrypted_password, :reset_password_token, :reset_password_sent_at, :remember_created_at]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  filter :email
  # For address dropdown with values of all addresses
  # filter :address_content, as: :select, collection: Address.pluck(:content)
  filter :address_content, as: :string
  filter :created_at
  filter :updated_at

  index do
    id_column
    column :email
    column "address" do |user|
      link_to user.address.content, admin_address_path(user.address) if user.address.present?
    end
    column :created_at
    column :updated_at
    column :status do |user|
      user.online?.zero? ? "Inactive" : "Active"
    end
    actions
  end
end
