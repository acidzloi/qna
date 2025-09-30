module Commenteble
  extend ActiveSupport::Concern

  included do
    has_many :comments, as: :commenteble, dependent: :destroy
  end
end
