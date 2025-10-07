class Services::NewAnswerNotification
  def send_new_answer(answer)
    answer.question.subscriptions.find_each do |subscription|
      NewAnswerNotificationMailer.new_answer(subscription.user, answer)&.deliver_later unless subscription.user.author?(answer)
    end
  end
end
