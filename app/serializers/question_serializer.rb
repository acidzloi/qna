class QuestionSerializer < ActiveModel::Serializer
  include AttachedConcern

  has_many :comments
  has_many :links

  attributes :id, :title, :body, :created_at, :updated_at, :user_id
end
