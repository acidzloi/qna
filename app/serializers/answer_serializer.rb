class AnswerSerializer < ActiveModel::Serializer
  include AttachedConcern

  has_many :comments
  has_many :links
  attributes :id, :body, :user_id, :question_id, :created_at, :updated_at, :best
end
