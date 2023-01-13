class AddJoinTableProductTypes < ActiveRecord::Migration[5.2]
  def change
    create_join_table :products, :types do |t|
      t.index :product_id
      t.index :type_id
    end
  end
end
