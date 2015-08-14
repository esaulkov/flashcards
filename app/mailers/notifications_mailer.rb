class NotificationsMailer < ApplicationMailer
  def pending_cards(user)
    mail(to: user.email, subject: "У Вас есть непроверенные карточки")
  end
end
