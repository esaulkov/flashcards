require "rails_helper"

describe "User locale" do
  let!(:user) { create(:user, password: "abracadabra", locale: :en) }

  context "when didn't logged in" do
    it "sets russian language" do
      visit log_in_path
      find(:xpath, "//a/img[@alt='ru']/..").click
      expect(page).to have_content "Вход в систему"
    end

    it "sets english language" do
      visit log_in_path
      find(:xpath, "//a/img[@alt='en']/..").click
      expect(page).to have_content "Sign in"
    end
  end

  context "when logged in" do
    before(:each) { login(user, "abracadabra") }

    it "sets english language as default" do
      expect(page).to have_content "Welcome"
    end

    it "sets language in user profile" do
      visit edit_profile_path
      select "ru", from: "profile_locale"
      fill_in "profile_password", with: "abracadabra"
      fill_in "profile_password_confirmation", with: "abracadabra"
      click_button "Update User"
      expect(page).to have_content "Ваш профиль"
    end
  end
end
