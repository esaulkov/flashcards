class UserMailer < ApplicationMailer
  def reset_password_email(user)
    @user = user
    @url = edit_home_reset_password_url(@user.reset_password_token)
    mail(to: user.email, subject: "Ваш пароль был сброшен")
  end
end
