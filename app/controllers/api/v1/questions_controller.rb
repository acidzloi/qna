class Api::V1::QuestionsController < ApplicationController
  authorize_resource

  before_action :question, except: %i[ index create ]

  def index
    @questions = Question.all
    render json: @questions, each_serializer: QuestionsSerializer
  end

  def show
    render json: @question, serializer: QuestionSerializer
  end

  def answers
    render json: @question.answers, each_serializer: AnswersSerializer
  end

  def create
    question = current_resource_owner.questions.build(question_params)

    if question.save
      render json: question, status: :created
    else
      render json: { errors: question.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @question.update(question_params)
      render json: question, status: :ok
    else
      render json: { errors: question.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @question.destroy
  end

  private

  def question
    @question ||= Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [],
                                     links_attributes: %i[id name url _destroy])
  end
end
