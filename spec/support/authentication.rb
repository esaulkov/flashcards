module AuthenticationForFeatureRequest
  def login(user, password)
    visit home_log_in_path
    find(:xpath, "//a/img[@alt='ru']/..").click
    fill_in "session_email", with: user.email
    fill_in "session_password", with: password
    click_button "Войти"
  end
end
