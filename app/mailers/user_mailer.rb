class UserMailer < ActionMailer::Base
  default from: "no-reply@flashcards.com"

  def reset_password_email(user)
    @user = user
    @url = edit_reset_password_url(@user.reset_password_token)
    mail(to: user.email, subject: "Ваш пароль был сброшен")
  end
end
