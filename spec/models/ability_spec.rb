require 'rails_helper'

RSpec.describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'user' do
    let(:user) { create(:user) }
    let(:second_user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:second_question) { create(:question, user: second_user) }
    let(:answer) { create(:answer, question: question, user: user) }
    let(:second_answer) { create(:answer, question: second_question, user: second_user) }

    describe 'question' do
      it { should be_able_to :create, Question }

      it { should be_able_to :update, question }
      it { should_not be_able_to :update, second_question }

      it { should be_able_to :destroy, question }
      it { should_not be_able_to :destroy, second_question }

      it { should be_able_to :vote_up, second_question }
      it { should_not be_able_to :vote_up, question }

      it { should be_able_to :vote_down, second_question }
      it { should_not be_able_to :vote_down, question }

      it 'recall' do
        second_question.vote_up(user)

        should be_able_to :recall, second_question
        should_not be_able_to :recall, question
      end
    end

    describe 'answer' do
      it { should be_able_to :create, Answer }

      it { should be_able_to :update, answer }
      it { should_not be_able_to :update, second_answer }

      it { should be_able_to :destroy, answer }
      it { should_not be_able_to :destroy, second_answer }

      it { should be_able_to :vote_up, second_answer }
      it { should_not be_able_to :vote_up, answer }

      it { should be_able_to :vote_down, second_answer }
      it { should_not be_able_to :vote_down, answer }

      it 'recall' do
        second_answer.vote_up(user)

        should be_able_to :recall, second_answer
        should_not be_able_to :recall, answer
      end

      it { should be_able_to :best, answer }
      it { should_not be_able_to :best, second_answer }
    end

    describe 'comments' do
      it { should be_able_to :create_comment, question }
      it { should be_able_to :create_comment, second_question }
    end


    describe 'badge' do
      it { should be_able_to :read, Badge }
    end

    describe 'links' do
      let(:link) { create(:link, linkable: question) }
      let(:second_link) { create(:link, linkable: second_question) }

      it { should be_able_to :destroy, link }
      it { should_not be_able_to :destroy, second_link }
    end

    describe 'attachments' do
      before do
        attach_file_to(question)
        attach_file_to(second_question)
      end

      it { should be_able_to :destroy, question.files.first }
      it { should_not be_able_to :destroy, second_question.files.first }
    end
  end
end
