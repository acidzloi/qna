class Answer < ApplicationRecord
  include Voteble
  include Commenteble
  include Rails.application.routes.url_helpers
  
  belongs_to :question, touch: true
  belongs_to :user
  has_many :links, dependent: :destroy, as: :linkable

  has_many_attached :files

  validates :body, presence: true

  accepts_nested_attributes_for :links, reject_if: :all_blank

  scope :sort_by_best, -> { order(best: :desc) }
  scope :best, -> { where(best: true) }

  after_create :send_new_answer

  def best!
    transaction do
      question.answers.best.update!(best: false)
      update!(best: true)
    end
  end

  def files_info
    files.map { |f| { id: f.id,
                      name: f.filename.to_s,
                      url: rails_blob_path(f, only_path: true) } }
  end

  def send_new_answer
    NewAnswerNotificationJob.perform_later(self)
  end
end
