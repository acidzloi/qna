class QuestionsController < ApplicationController
  include Voted
  include Commented
  
  before_action :authenticate_user!, except: [ :index, :show ]
  before_action :gon_question_id, only: [ :show, :create ]
  before_action :subscription, only: :show
  after_action :publish_question, only: :create

  authorize_resource

  def index
    @questions = Question.all
  end

  def show 
    @answer = Answer.new
    @answer.links.new
    @answers = @question.answers
  end

  def new
    question.links.new
    question.badge ||= Badge.new
  end

  def edit; end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to @question, notice: "Your question was succesfully created"
    else
      render :new
    end
  end

  def update
    question.update(question_params)
  end

  def destroy
    question.destroy
    redirect_to questions_path, notice: "Question successfully deleted."
  end

  private

  def set_question
    @question = Question.find(params[:id])
  end

  def question
    @question ||= params[:id] ? Question.with_attached_files.find(params[:id]) : Question.new
  end

  helper_method :question

  def question_params
    params.require(:question).permit(:title, :body,
                                     files: [],
                                     links_attributes: [ :name, :url ],
                                     badge_attributes: [ :title, :image ])
  end

  def publish_question
    return if @question.errors.any?

    ActionCable.server.broadcast("questions", question.to_json)
  end

  def gon_question_id
    gon.question_id = question.id
  end

  def subscription
    @subscription ||= current_user&.subscriptions&.find_by(question: @question)
  end
end
