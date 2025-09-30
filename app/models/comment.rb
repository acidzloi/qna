class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commenteble, polymorphic: true


  validates :body, presence: true
end
