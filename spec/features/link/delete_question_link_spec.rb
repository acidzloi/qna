require 'rails_helper'

feature 'User can remove his question links' do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question, user: author) }
  given!(:link) { create(:link, linkable: question) }

  describe 'Authenticated user', js: true do
    scenario 'author of the question delete link' do
      sign_in(author)
      visit question_path(question)

      within ".link-#{link.id}" do
        click_on 'Delete'
      end

      within ".question" do
        expect(page).to_not have_link link.url
      end
    end

    scenario 'user of the question can not delete link' do
      sign_in(user)
      visit question_path(question)

      within ".link-#{link.id}" do
        expect(page).to_not have_link 'Delete'
      end
    end
  end

  describe 'Non-logged in user', js: true do
    scenario 'can not delete question link' do
      visit question_path(question)

      within ".link-#{link.id}" do
        expect(page).to_not have_link 'Delete'
      end
    end
  end
end
