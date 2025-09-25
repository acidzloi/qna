require 'rails_helper'

feature 'Best answer' do
  given!(:author) { create(:user) }
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given!(:badge) { create(:badge, question: question) }
  given!(:first_answer) { create(:answer, question: question, user: author) }
  given!(:second_answer) { create(:answer, question: question, user: author) }

  before do
    add_image(badge)
  end

  scenario 'Non-logged in user can not set best answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Best'
  end

  scenario 'User can not set best answer' do
    sign_in(user)
    visit question_path(question)

    expect(page).to_not have_link 'Best'
  end

  describe 'Authenticated user is question author', js: true do
    before { sign_in author }
    before { visit question_path(question) }

    scenario 'best answer link not available for best answer' do
      within(".answer-#{first_answer.id}") do
        click_on 'Best'

        expect(page).to_not have_link 'Best'
      end
    end

    scenario 'best answer link available for not best answer' do
      within(".answer-#{first_answer.id}") do
        click_on 'Best'
      end

      within(".answer-#{second_answer.id}") do
        expect(page).to have_link 'Best'
      end
    end

    scenario 'best answer first' do
      expect(page.first('.answer')[:class]).to have_content("answer-#{first_answer.id}")

      within(".answer-#{second_answer.id}") do
        click_on 'Best'

        wait_ajax_request
      end

      expect(page.first('.answer')[:class]).to_not have_content("answer-#{first_answer.id}")
      expect(page.first('.answer')[:class]).to have_content("answer-#{second_answer.id}")
    end
  end
end
