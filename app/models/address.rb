class Address < ApplicationRecord
  belongs_to :user
  validates_presence_of :content
end
