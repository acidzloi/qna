require 'rails_helper'

feature 'Subscribe to question' do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question, user: author) }

  describe 'author', js: true do
    before do
      sign_in(author)
      visit question_path(question)
    end

    scenario 'can not subscribe from the question' do
      expect(page).to_not have_link 'Subscribe'
      expect(page).to have_link 'Unsubscribe'
    end

    scenario 'can unsubscribe from the question' do
      click_on 'Unsubscribe'

      expect(page).to_not have_link 'Unubscribe'
      expect(page).to have_link 'Subscribe'
    end
  end

  describe 'user', js: true do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'can subscribe from the question' do
      click_on 'Subscribe'

      expect(page).to_not have_link 'Subscribe'
      expect(page).to have_link 'Unsubscribe'
    end

    scenario 'can unsubscribe from the question' do
      click_on 'Subscribe'
      click_on 'Unsubscribe'

      expect(page).to_not have_link 'Unubscribe'
      expect(page).to have_link 'Subscribe'
    end
  end

  describe 'Unauthenticated user', js: true do
    scenario 'can not subscribers' do
      visit question_path(question)

      expect(page).to_not have_content 'Subscribe'
      expect(page).to_not have_link 'Unubscribe'
    end
  end
end
