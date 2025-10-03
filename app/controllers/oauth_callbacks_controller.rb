class OauthCallbacksController < ApplicationController
  before_action :auth, :email, :email_confirmation, only: %i[github vkontakte]

  def github
    sing_in_by_oauth(auth, email)
  end

  def vkontakte
    sing_in_by_oauth(auth, email)
  end

  def send_email
    session[:email] = params[:email]
    user = User.find_or_create(params[:email])
    confirmed_message(user)
  end

  private

  def auth
    @auth = request.env["omniauth.auth"]
  end

  def email
    @email = @auth.info[:email] || User.find_by_auth(@auth)&.email || session[:email]
  end

  def sing_in_by_oauth(auth, email)
    @user = User.find_for_oauth(auth, email)

    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: auth.provider.capitalize) if is_navigational_format?
    else
      redirect_to root_path, alert: "Something went wrong"
    end
  end

  def confirmed_message(user)
    if user.confirmed?
      redirect_to questions_path, notice: "You can sign in by provider"
    else
      redirect_to user_session_path, notice: "We send you email on #{user.email} for confirmation"
    end
  end

  def email_confirmation
    render "shared/email" unless @email
  end
end
