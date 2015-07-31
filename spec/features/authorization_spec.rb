require "rails_helper"

describe "User authorization" do
  before(:all) { @user = create(:user, password: "abracadabra") }

  context "check access restriction" do
    it "redirects to login page from main page" do
      visit root_path
      expect(page).to have_content "Пожалуйста, пройдите авторизацию"
    end
    it "redirects to login page from cards page" do
      visit cards_path
      expect(page).to have_content "Пожалуйста, пройдите авторизацию"
    end
    it "redirects to login page from profile page" do
      visit profile_path
      expect(page).to have_content "Пожалуйста, пройдите авторизацию"
    end
    it "redirects to main page after authorization" do
      login(@user, "abracadabra")
      expect(page).to have_content "Проверка знаний"
    end
    it "remembers last page before authorization" do
      visit profile_path
      login(@user, "abracadabra")
      expect(page).to have_content "Ваш профиль"
    end
    it "render new template if password is incorrect" do
      login(@user, password: "abracadabr")
      expect(page).to have_content "Вход в систему"
    end
  end

  context "restore password" do
    it "send a letter" do
      visit new_reset_password_path
      fill_in "reset_email", with: @user.email
      click_button "Выслать инструкции"
      expect(ActionMailer::Base.deliveries.count).to eql(1)
    end
  end
end
