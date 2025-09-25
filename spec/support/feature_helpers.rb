module FeatureHelpers
  def sign_in(user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
  end
end

def add_image(badge)
  badge.image.attach(
    io: File.open(Rails.root.join('public/icon.png').to_s),
    filename: 'icon.png'
  )
end
