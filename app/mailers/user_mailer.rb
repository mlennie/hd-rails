class UserMailer < ActionMailer::Base
  default from: 'Happy Dining <no-reply@happydining.fr>'

  def password_reset user
    @user = user
    @token = user.reset_password_token
    mail to: @user.email, subject: "Happy Dining Password Reset"
  end

  def new_reservation reservation
  	@reservation = reservation
  	@user = reservation.user
  	@restaurant = reservation.restaurant
  end
end
