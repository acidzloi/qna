require 'rails_helper'

feature 'All users can view questions' do
  given(:user) { create(:user) }
  given!(:questions) { create_list(:question, 3, user: user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
    end

    scenario 'Can view questions' do
      visit questions_path

      questions.each { |question| expect(page).to have_content question.title }
    end
  end

  scenario 'Non-logged in user can view questions' do
    visit questions_path

    questions.each { |question| expect(page).to have_content question.title }
  end
end
