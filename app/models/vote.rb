class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :voteble, polymorphic: true, touch: true

  validates :vote, presence: true
  validates_inclusion_of :vote, in: -1..1
end
