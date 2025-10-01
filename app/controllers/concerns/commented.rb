module Commented
  extend ActiveSupport::Concern

  included do
    before_action :commenteble, only: :create_comment
    after_action :publish_comment, only: :create_comment
  end

  def create_comment
    if current_user
      @comment = @commenteble.comments.new(comment_params)
      @comment.user = current_user
      @comment.save
    end
  end

  private

  def commenteble
    @commenteble = model_klass.find(params[:id])
  end

  def model_klass
    controller_name.classify.constantize
  end

  def publish_comment
    return if @comment.errors.any?

    question_id = @comment.commenteble_type == "Question" ? @comment.commenteble_id : @comment.commenteble.question_id

    ActionCable.server.broadcast(
      "question_#{question_id}_comments", {
        comment: @comment,
        user_email: @comment.user.email
      }.to_json
    )
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
