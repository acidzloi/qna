class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  has_many :links, dependent: :destroy, as: :linkable

  has_many_attached :files

  validates :body, presence: true

  accepts_nested_attributes_for :links, reject_if: :all_blank

  scope :sort_by_best, -> { order(best: :desc) }
  scope :best, -> { where(best: true) }

  def best!
    transaction do
      question.answers.best.update!(best: false)
      update!(best: true)
    end
  end
end
