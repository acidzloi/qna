class NewAnswerNotificationJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Services::NewAnswerNotification.new.send_new_answer(answer)
  end
end
