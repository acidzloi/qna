require 'rails_helper'

feature 'Add comment to answer' do
  given(:user) { create(:user) }
  given(:second_user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  describe 'Authenticated user', js: true do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'add new comment to answer' do
      within ".answer-#{answer.id}" do
        fill_in 'Comment', with: 'Test comment'
        click_on 'Add comment'

        expect(page).to have_content 'Test comment'
      end
    end
  end

  context 'mulitple sessions', js: true do
    scenario "answers comment appears on another user's page" do
      Capybara.using_session('second_user') do
        sign_in(second_user)
        visit question_path(question)
      end

      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)

        within ".answer-#{answer.id}" do
          fill_in 'Comment', with: 'Test comment'
          click_on 'Add comment'

          expect(page).to have_content 'Test comment'
        end
      end

      Capybara.using_session('second_user') do
        within ".answer-#{answer.id}" do
          expect(page).to have_content 'Test comment'
        end
      end
    end
  end
end
