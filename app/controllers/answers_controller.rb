class AnswersController < ApplicationController
  before_action :authenticate_user!
 
  def create
    @answer = question.answers.new(answer_params)
    @answer.user = current_user

    if @answer.save
      redirect_to question, notice: "Answer successfully created."
    else
      render "questions/show"
    end
  end

  def destroy
    flash[:notice] = if current_user.author?(answer)
      answer.destroy
      "Answer successfully deleted."
    else
      "Only author can delete answer."
    end

    redirect_to @answer.question
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
