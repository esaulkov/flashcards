class ApplicationMailer < ActionMailer::Base
  default from: "#{ENV['SITE_NAME']} <#{ENV['MAIL_FROM']}>"
  layout "mailer"
end
