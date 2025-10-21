class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commenteble, polymorphic: true, touch: true


  validates :body, presence: true
end
