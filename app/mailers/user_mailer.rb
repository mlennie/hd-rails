class UserMailer < ActionMailer::Base
  default from: 'no-reply@happydining.com'


  def password_reset user
    @user = user
    @token = user.authentication_token
    mail to: @user.email, subject: "Happy Dining Password Reset"
  end
end
