ActiveAdmin.register Product do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :name, :description, :price
  #
  # or
  #
  # permit_params do
  #   permitted = [:name, :description, :price]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  filter :name
  filter :price, as: :numeric
  filter :description
  filter :created_at
  filter :updated_at

  index do
    selectable_column
    id_column
    column :name
    column :description
    column :price
    actions
  end
end
