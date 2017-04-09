class ApplicationMailer < ActionMailer::Base
  include SendGrid

  default from: 'bookstore@svatok-bookstore-svatok.c9users.io'
  layout 'mailer'
end
