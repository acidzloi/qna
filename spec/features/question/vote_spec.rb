require 'rails_helper'

feature 'User can vote for a question' do
  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given(:question) { create(:question, user: author) }

  describe 'Authenticated user' do
    describe 'Author', js: true do
      before { sign_in(author) }
      before { visit question_path(question) }

      scenario "can not vote" do
        expect(page).to_not have_link '+'
        expect(page).to_not have_link '-'
      end
    end

    describe 'User', js: true do
      before { sign_in(user) }
      before { visit question_path(question) }

      scenario 'can vote up' do
        within ".vote-#{question.class}-#{question.id}" do
          click_on '+'
          expect(page).to have_content '1'
        end
      end

      scenario 'can vote down' do
        within ".vote-#{question.class}-#{question.id}" do
          click_on '-'
          expect(page).to have_content '-1'
        end
      end

      scenario 'can vote only once' do
        within ".vote-#{question.class}-#{question.id}" do
          click_on '+'
          expect(page).to_not have_link '+'
          expect(page).to_not have_link '-'
        end
      end

      scenario 'can recall' do
        within ".vote-#{question.class}-#{question.id}" do
          click_on '+'
          expect(page).to have_link 'recall'

          click_on 'recall'
          expect(page).to have_content '0'
          expect(page).to_not have_link 'recall'
        end
      end
    end
  end

  describe 'Non-logged in user', js: true do
    before { visit question_path(question) }

    scenario 'can not vote' do
      within ".vote-#{question.class}-#{question.id}" do
        click_on '+'

        expect(page).to have_content 'You need to sign in or sign up before continuing.'
      end
    end
  end
end
