require 'rails_helper'

feature 'User can create answer' do
  given(:user) { create(:user) }
  given(:second_user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'create answer' do
      fill_in 'Answer', with: 'first answer'
      click_on 'Answer'

      expect(page).to have_content 'Your answer successfully created.'
      expect(page).to have_content 'first answer'
    end

    scenario 'create answer with errors', js: true do
      click_on 'Answer'

      expect(page).to have_content "Body can't be blank"
    end

    scenario 'create answer with attached file', js: true do
      fill_in 'Body', with: 'first answer'
      attach_file 'File', [ "#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb" ]
      click_on 'Answer'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    context 'mulitple sessions', js: true do
      given(:url) { 'https://test.local' }

      scenario "answer appears on another user's page" do
        Capybara.using_session('second_user') do
          sign_in(second_user)
          visit question_path(question)
        end

        Capybara.using_session('user') do
          sign_in(user)
          visit question_path(question)

          fill_in 'Answer', with: 'first answer'

          attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"

          fill_in 'Link name', with: 'Test'
          fill_in 'Url', with: url

          click_on 'Answer'

          expect(page).to have_content 'first answer'
          expect(page).to have_link 'rails_helper.rb'
          expect(page).to have_link 'Test', href: url
        end

        Capybara.using_session('second_user') do
          expect(page).to have_content 'first answer'
          expect(page).to have_link 'rails_helper.rb'
          expect(page).to have_link 'Test', href: url
        end
      end
    end
  end

  scenario 'Unauthenticated user tries to create a answer' do
    visit question_path(question)
    click_on 'Answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  scenario 'Authenticated user creates answer with errors', js: true do
    sign_in(user)
    visit question_path(question)

    click_on 'Answer'

    expect(page).to have_content "Body can't be blank"
  end
end
