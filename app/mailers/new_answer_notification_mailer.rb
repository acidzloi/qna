class NewAnswerNotificationMailer < ApplicationMailer
  def new_answer(answer, user)
    @answer = answer

    mail to: user.email, subject: "New answer notification"
  end
end
