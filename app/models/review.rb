class Review < ApplicationRecord
  include Likable
  belongs_to :user
  belongs_to :reviewable, polymorphic: true
  validates_presence_of :content
end
