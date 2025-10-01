class AnswersController < ApplicationController
  include Voted
  include Commented
  
  before_action :authenticate_user!

  after_action :publish_answer, only: :create
 
  def create
    @answer = question.answers.create(answer_params)
    @answer.user = current_user
    
    if @answer.save
      flash[:notice] = "Your answer successfully created."
      redirect_to question_path(question)
    else
      render 'questions/show'
    end
  end

  def destroy
    if current_user.author?(answer)
      answer.destroy
      redirect_to answer.question, notice: 'Your answer successfully deleted.'
    else
      redirect_to answer.question, notice: 'You are not authorized to delete this answer.'
    end
  end

  
  def update
    if current_user.author?(answer)
      answer.update(answer_params)
      @question = @answer.question
    else
      redirect_to answer.question
    end
  end

  def best
    @question = answer.question
    if current_user&.author?(@question)
      answer.best!
      answer.user.add_badge!(@question.badge) if @question.badge.present?
    end
  end

  private

  def question
    @question = Question.with_attached_files.find(params[:question_id])
  end

  helper_method :question

  def answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [ :name, :url ])
  end

  def publish_answer
    return if @answer.errors.any?

    ActionCable.server.broadcast(
      "question_#{@answer.question_id}_answers", {
        answer: @answer,
        files: @answer.files_info,
        links: @answer.links,
        total_votes: @answer.total_votes
      }.to_json
    )
  end
end
