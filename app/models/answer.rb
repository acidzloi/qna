class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  scope :sort_by_best, -> { order(best: :desc) }
  scope :best, -> { where(best: true) }

  def best!
    transaction do
      question.answers.best.update!(best: false)
      update!(best: true)
    end
  end
end
