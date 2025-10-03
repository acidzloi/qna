module OmniauthEnvHelpers
  def omniauth_env (provider, email: nil)
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @request.env['omniauth.auth'] = mock_auth provider, email: email
  end
end
