require "rails_helper"

RSpec.describe NewAnswerNotificationMailer, type: :mailer do
  describe 'new_answer' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, question: question, user: user) }
    let(:mail) { NewAnswerNotificationMailer.new_answer(answer, user) }

    it 'renders the headers' do
      expect(mail.subject).to eq('New answer notification')
      expect(mail.to).to eq([ user.email ])
      expect(mail.from).to eq([ 'from@example.com' ])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match(answer.body)
    end
  end
end
