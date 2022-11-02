class CreateReviews < ActiveRecord::Migration[5.2]
  def change
    create_table :reviews do |t|
      t.references :user, foreign_key: true
      t.integer :reviewable_id
      t.string :reviewable_type
      t.string :content

      t.timestamps
    end
  end
end
