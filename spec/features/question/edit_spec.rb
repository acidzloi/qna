require 'rails_helper'

feature 'User can edit his question', %q(
  "In order to correct mistakes
  As an author of question
  I'd like ot be able to edit my question"
) do
  given!(:author) { create(:user) }
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: author) }

  scenario 'Unauthenticated can not edit question' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  scenario "User can not edit question" do
    sign_in(user)
    visit question_path(question)

    within '.question' do
      expect(page).to_not have_link 'Edit'
    end
  end

  describe 'Author' do
    before { sign_in(author) }
    before do
      visit question_path(question)
      click_on 'Edit question'
    end

    scenario 'edits his question', js: true do
      within '.question' do
        fill_in 'Your title', with: 'edited title'
        fill_in 'Your question', with: 'edited question'
        click_on 'Save'

        expect(page).to_not have_content question.title
        expect(page).to_not have_content question.body
        expect(page).to have_content 'edited title'
        expect(page).to have_content 'edited question'
        expect(page).to_not have_selector 'textfield'
        expect(page).to_not have_selector('textarea', id: 'question_body')
      end
    end

    scenario 'edits his question with errors', js: true do
      within '.question' do
        fill_in 'Your title', with: ''
        fill_in 'Your question', with: ''
        click_on 'Save'

        expect(page).to have_content question.title
        expect(page).to have_content question.body
        expect(page).to_not have_selector 'textfield'
        expect(page).to have_selector 'textarea'
      end

      expect(page).to have_content "Title can't be blank"
      expect(page).to have_content "Body can't be blank"
    end

    scenario 'edits his question with attach files', js: true do
      within '.question' do
        fill_in 'Your title', with: 'edited title'
        fill_in 'Your question', with: 'edited question'
        attach_file 'Question files', [ "#{Rails.root.join('spec/rails_helper.rb')}", "#{Rails.root.join('spec/spec_helper.rb')}" ]

        click_on 'Save'

        expect(page).to_not have_selector 'file'
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'edits his question', js: true do

      within '.question' do
        fill_in 'Your title', with: 'edited title'
        fill_in 'Your question', with: 'edited question'
        attach_file 'Question files', [ "#{Rails.root.join('spec/rails_helper.rb')}", "#{Rails.root.join('spec/spec_helper.rb')}" ]

        click_on 'Save'

        expect(page).to_not have_selector 'file'
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario "tries to edit other user's answers" do
      within '.question' do
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
