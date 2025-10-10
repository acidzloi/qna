require 'sphinx_helper'

RSpec.describe 'Services::SearchService' do
  describe '.call' do
    let(:query) { 'test' }

    describe 'search in: areas' do
      Services::SearchService::SEARCH_AREA.each do |search_area|
        it "calls search in :#{search_area}" do
          expect(search_area.singularize.classify.constantize).to receive(:search).with(query)
          Services::SearchService.call(query, search_area)
        end
      end
    end

    describe 'search in: All' do
      it 'calls search in all' do
        expect(ThinkingSphinx).to receive(:search).with(query)
        Services::SearchService.call(query, 'Test')
      end
    end

    describe 'returns search result', sphinx: true, js: true do
      let!(:user) { create(:user, email: 'test@test.local',
                            password: '12345678', password_confirmation: '12345678',
                            confirmed_at: Time.current.to_s) }
      let!(:question) { create(:question, user: user, title: 'test', body: "test") }
      let!(:answer) { create(:answer, question: question, user: user, body: 'test') }

      let!(:second_user) { create(:user, email: 'second@second.local',
                                   password: '12345678', password_confirmation: '12345678',
                                   confirmed_at: Time.current.to_s) }
      let!(:second_question) { create(:question, user: second_user, title: 'second', body: "second") }
      let!(:second_answer) { create(:answer, question: second_question, user: second_user, body: 'second') }

      it 'returns only question' do
        ThinkingSphinx::Test.run do
          expect((Services::SearchService.call(query, 'Questions'))).to match_array [ question ]
        end
      end

      it 'returns only answer' do
        ThinkingSphinx::Test.run do
          expect((Services::SearchService.call(query, 'Answers'))).to match_array [ answer ]
        end
      end

      it 'returns only objects' do
        ThinkingSphinx::Test.run do
          expect((Services::SearchService.call(query, 'Test'))).to match_array [ question, answer, user ]
        end
      end
    end
  end
end
