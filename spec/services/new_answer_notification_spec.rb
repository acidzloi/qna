require 'rails_helper'

RSpec.describe Services::NewAnswerNotification do
  let(:subscribers) { create_list(:user, 3) }
  let(:unsubscribers) { create_list(:user, 2) }
  let(:answer_author) { create(:user) }
  let(:question) { create(:question, user: subscribers.first) }
  let(:answer) { create(:answer, question: question, user: answer_author) }

  after { subject.send_new_answer(answer) }

  it 'send notification of new answer to the author' do
    expect(NewAnswerNotificationMailer).to receive(:new_answer).with(subscribers.first, answer).and_call_original
  end

  it 'send notification of new answer to the all subscribers' do
    question.subscriptions.create(user: subscribers[1])
    question.subscriptions.create(user: subscribers[2])

    subscribers.each do |user|
      expect(NewAnswerNotificationMailer).to receive(:new_answer).with(user, answer).and_call_original
    end
  end

  it 'not send notification of new answer to the answer author' do
    expect(NewAnswerNotificationMailer).to_not receive(:new_answer).with(answer_author, answer).and_call_original
  end

  it 'not send notification of new answer to the unsubscribers' do
    unsubscribers.each do |user|
      expect(NewAnswerNotificationMailer).to_not receive(:new_answer).with(user, answer).and_call_original
    end
  end
end
