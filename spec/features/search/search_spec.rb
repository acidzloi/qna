require 'sphinx_helper'

feature 'User can search' do
  given!(:user) { create(:user, email: 'test@test.local') }
  given!(:question) { create(:question, body: 'test') }
  given!(:answer) { create(:answer, body: 'test') }
  given!(:comment) { create(:comment, user: user, commenteble: question, body: 'test') }

  Services::SearchService::SEARCH_AREA.each do |search_area|
    scenario "search in: #{search_area}", sphinx: true, js: true do
      ThinkingSphinx::Test.run do
        visit questions_path

        within '.search' do
          fill_in 'search_string', with: 'test*'
          select search_area, from: 'search_area'
          click_on 'Search'
        end

        within '.search_results' do
          expect(page).to have_content 'Search results:'
          expect(page).to have_content search_area.singularize
        end
      end
    end
  end

  scenario 'search in: All', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      visit questions_path

      within '.search' do
        fill_in 'search_string', with: 'test'
        select 'All', from: 'search_area'
        click_on 'Search'
      end

      within '.search_results' do
        expect(page).to have_content(question.body)
        expect(page).to have_content(answer.body)
        expect(page).to have_content(comment.body)
        expect(page).to have_content(user.email)
      end
    end
  end

  scenario 'result: No matches found!', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      visit questions_path

      within '.search' do
        fill_in 'search_string', with: 'not found'
        select 'All', from: 'search_area'
        click_on 'Search'
      end

      expect(page).to have_content('No matches found!')
    end
  end
end
