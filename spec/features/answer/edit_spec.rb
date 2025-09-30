require 'rails_helper'

feature 'User can edit his answer', %q(
  "In order to correct mistakes
  As an author of answer
  I'd like ot be able to edit my answer"
) do
  given!(:author) { create(:user) }
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given!(:answer) { create(:answer, question: question, user: author) }

  scenario 'Unauthenticated can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  scenario "User can not edit other user's answers" do
    sign_in(user)
    visit question_path(question)

    within '.answer-#{answer.id}' do
      expect(page).to_not have_link 'Edit answer'
    end
  end

  describe 'Authenticated user' do
    before do
      sign_in(author)
      visit question_path(question)

      click_on 'Edit answer'
    end

    scenario 'edits his answer', js: true do
      within '.answer-#{answer.id}' do
        fill_in 'Your answer', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector('textarea', id: 'answer_body')
      end
    end

    scenario 'edits his answer with attach files', js: true do
      within '.answer-#{answer.id}' do
        fill_in 'Your answer', with: 'edited answer'
        attach_file 'Answers files', [ "#{Rails.root.join('spec/rails_helper.rb')}", "#{Rails.root.join('spec/spec_helper.rb')}" ]
        save_page
        click_on 'Save'

        expect(page).to_not have_selector 'file'
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'edits his answer with errors', js: true do
      within '.answer-#{answer.id}' do
        fill_in 'Your answer', with: ''
        click_on 'Save'


        expect(page).to have_content answer.body
        expect(page).to have_selector('textarea', id: 'answer_body')
      end

      expect(page).to have_content "Body can't be blank"
    end

    scenario "tries to edit other user's answers" do
      within '.answer-#{answer.id}' do
        click_on 'add link'

        fill_in 'Link name', with: 'Test'
        fill_in 'Url', with: 'http://test.local'

        click_on 'Save'

        expect(page).to have_link 'Test', href: 'http://test.local'
        expect(page).to_not have_selector 'textfield'
      end
    end
  end
end
