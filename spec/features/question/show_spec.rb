require 'rails_helper'

feature 'User can see questions and answers to him' do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answers) { create_list(:answer, 3, question: question, user: user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
    end

    scenario 'can see questions and answers to him' do
      visit question_path(question)

      expect(page).to have_content question.title
      expect(page).to have_content question.body
      answers.each { |answer| expect(page).to have_content answer.body }
    end
  end

  scenario 'Non-logged in can see questions and answers to him' do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    answers.each { |answer| expect(page).to have_content answer.body }
  end
end
