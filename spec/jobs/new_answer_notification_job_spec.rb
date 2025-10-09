require 'rails_helper'

RSpec.describe NewAnswerNotificationJob, type: :job do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }
  let(:service) { double('Services::NewAnswerNotification') }

  before do
    allow(Services::NewAnswerNotification).to receive(:new).and_return(service)
  end

  it 'calls Services::NewAnswerNotification#send_new_answer' do
    expect(service).to receive(:send_new_answer).with(answer)
    NewAnswerNotificationJob.perform_now(answer)
  end
end
