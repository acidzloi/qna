require 'rails_helper'

feature 'All users can view gist content' do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question, user: author) }
  given(:answer) { create(:answer, question: question, user: author) }
  given!(:question_link) { create(:link, :gist_link, linkable: question) }
  given!(:answer_link) { create(:link, :gist_link, linkable: answer) }
  given!(:gist_content) { 'Test' }

  describe 'User', js: true do
    before { visit question_path(question) }

    scenario 'visible gist content in question' do
      within ".link-#{question_link.id}" do
        expect(page).to have_content gist_content
      end
    end

    scenario 'visible gist content in answer' do
      within ".link-#{answer_link.id}" do
        expect(page).to have_content gist_content
      end
    end
  end
end
