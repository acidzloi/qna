class DailyDigestMailer < ApplicationMailer
  def digest(user)
    @questions = Question.where("created_at > ?", Date.current.yesterday)

    mail to: user.email, subject: "Questions daily digest" if @questions.any?
  end
end
