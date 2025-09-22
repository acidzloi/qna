class AnswersController < ApplicationController
  before_action :authenticate_user!
 
  def create
    @answer = question.answers.create(answer_params)
    @answer.user = current_user

    flash[:notice] = "Your answer successfully created." if @answer.save
  end

  def destroy
    if current_user.author?(answer)
      answer.destroy
      flash[:notice] = "Answer successfully deleted."
    else
      flash[:notice] = "Only author can delete answer."
      redirect_to answer.question
    end

    redirect_to @answer.question
  end

  
  def update
    if current_user.author?(answer)
      answer.update(answer_params)
      @question = @answer.question
    else
      redirect_to answer.question
    end
  end

  private

  def question
    @question = Question.find(params[:question_id])
  end

  helper_method :question

  def answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
