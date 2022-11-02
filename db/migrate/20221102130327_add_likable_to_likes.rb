class AddLikableToLikes < ActiveRecord::Migration[5.2]
  def change
    add_reference :likes, :likable, polymorphic: true, index: true
  end
end
