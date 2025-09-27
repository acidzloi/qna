require 'rails_helper'

feature 'User can remove his question attachments' do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question, user: author) }

  before do
    attach_file_to(question)
  end

  describe 'Authenticated user', js: true do
    scenario 'author of the question delete the attachment' do
      sign_in(author)
      visit question_path(question)

      within ".attachment-file-#{question.files.first.id}" do
        click_on 'Delete attachment'
      end

      within ".question" do
        expect(page).to_not have_link 'rails_helper.rb'
      end
    end

    scenario 'Not author of the question delete the attachment' do
      sign_in(user)
      visit question_path(question)

      within ".attachment-file-#{question.files.first.id}" do
        expect(page).to_not have_link 'Delete attachment'
      end
    end

    scenario 'not authenticated user delete question attachment' do
      visit question_path(question)

      within ".attachment-file-#{question.files.first.id}" do
        expect(page).to_not have_link 'Delete attachment'
      end
    end
  end
end
