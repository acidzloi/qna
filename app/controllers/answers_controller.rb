class AnswersController < ApplicationController
  include Voted
  
  before_action :authenticate_user!
 
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
    if current_user
      answer.best!
      answer.user.add_badge!(answer.question.badge)
    else
      redirect_to answer.question
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
end
