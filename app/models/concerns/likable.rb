module Likable
  extend ActiveSupport::Concern

  included do
    has_many :likes, as: :likable
  end
end