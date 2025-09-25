require 'rails_helper'

feature 'The user can view badges' do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:badges) { create_list(:badge, 2, question: question) }


  before { sign_in(user) }
  before do
    badges.each do |badge|
      user.add_badge!(badge)
      add_image(badge)
    end
  end

  scenario "User can view link 'Badges'" do
    expect(page).to have_link 'Badges'
  end

  scenario 'User can view list of badges' do
    visit badges_path

    user.badges.each do |badge|
      expect(page).to have_content badge.question.title
      expect(page).to have_css("img[src*='#{badge.image.filename}']")
      expect(page).to have_content badge.title
    end
  end
end
