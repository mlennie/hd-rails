class UserMailer < ActionMailer::Base
  default from: 'Happy Dining <no-reply@happydining.fr>'

  def password_reset user
    @user = user
    @token = user.reset_password_token
    mail to: @user.email, subject: "Happy Dining Password Reset"
  end

  def new_reservation reservation
  	@reservation = reservation
  	@time = reservation.time.strftime("%m/%d/%Y, at %H:%M") 
  	@user = reservation.user
  	@restaurant = reservation.restaurant
  	@email = @user.email
  	mail to: @email, subject: "New Reservation Through Happy Dining"
  end

  def new_referral_registration user
    @user = user
    @referrer = User.find(user.referrer_id)
    @email = @referrer.email
    mail to: @email, subject: "Congrats! You have recieved one friend referral."
  end

  def new_referral_payment user
    @user = user
    @referrer = User.find(user.referrer_id)
    @amount = user.referral_amount
    @email = @referrer.email
    mail to: @email, subject: "Congrats! You have recieved one friend referral."
  end
end
