module AuthenticationForFeatureRequest
  def login(user, password)
    visit log_in_path
    fill_in "session_email", with: user.email
    fill_in "session_password", with: password
    click_button "Войти"
  end
end
