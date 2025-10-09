class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :question, only: :create
  before_action :subscription, only: :destroy

  authorize_resource

  def create
    @subscription = current_user.subscriptions.create(question: @question)
  end

  def destroy
    @subscription.destroy
  end

  private

  def question
    @question = Question.find(params[:question_id])
  end

  def subscription
    @subscription = Subscription.find(params[:id])
  end
end
