class ReputationJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Services::Reputation.calculate(object)
  end
end
