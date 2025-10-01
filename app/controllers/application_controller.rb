class ApplicationController < ActionController::Base

  before_action :gon_user, unless: :devise_controller?
  allow_browser versions: :modern

  private

  def gon_user
    gon.current_user = current_user
  end

end
