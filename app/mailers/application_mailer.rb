class ApplicationMailer < ActionMailer::Base
  default to: 'kozak1622@gmail.com'
  default from: 'support@kursy-app.herokuapp.com'
  layout 'mailer'
end
