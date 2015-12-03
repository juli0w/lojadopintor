class NotificationMailer < ApplicationMailer
  default from: "notification@ecommerce.com"

  ADMIN_EMAILS = ["juli0w@hotmail.com"]

  def contact(message)
    @message = message
    mail(to: ADMIN_EMAILS, subject: "Contato - Commerce")
  end
end
