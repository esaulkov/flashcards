class UserMailer < ActionMailer::Base
  default from: "#{ENV['SITE_NAME']} <#{ENV['MAIL_FROM']}>"

  def reset_password_email(user)
    @user = user
    @url = edit_reset_password_url(@user.reset_password_token)
    mail(to: user.email, subject: "Ваш пароль был сброшен")
  end
end
