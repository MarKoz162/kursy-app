class ApplicationMailer < ActionMailer::Base
  default from: 'support@kursy-app.herokuapp.com'
  layout 'mailer'
end
