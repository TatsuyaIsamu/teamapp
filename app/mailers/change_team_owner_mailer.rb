class ChangeTeamOwnerMailer < ApplicationMailer
  default from: "from@example.com"
  layout "mailer"
  def change_team_owner(email, password)
    @email = email
    @password = password
    mail to: @email, subject: I18n.t('views.messages.complete_registration')
  end
end
