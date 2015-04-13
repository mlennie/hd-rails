class UserMailer < ActionMailer::Base
  default from: 'Happy Dining <hello@happydining.fr>'

  def password_reset user
    @user = user
    @token = user.reset_password_token
    mail to: @user.email, subject: "Reconfigurer votre mot de passe Happy Dining"
  end

  def new_reservation reservation
  	@reservation = reservation
  	@time = reservation.time.strftime("%d/%m/%Y, à %H:%M") 
  	@user = reservation.user
  	@restaurant = reservation.restaurant
  	@email = @user.email
    @user_contribution = @reservation.user_contribution
  	mail to: @email, subject: "Réservation confirmée"
  end

  def new_referral_registration user
    @user = user
    @referrer = User.find(user.referrer_id)
    @email = @referrer.email
    @amount = ENV["REFERRAL_AMOUNT"].to_s
    mail to: @email, subject: "Félicitations vous avez parrainé quelqu'un."
  end

  def new_referral_payment user
    @user = user
    @referrer = User.find(user.referrer_id)
    @amount = user.referral_amount
    @email = @referrer.email
    mail to: @email, subject: "Félicitations, " + @user.referral_amount.to_s + " euros de plus."
  end

  def received_reservation_money user, amount, reservation
    @user = user
    @email = user.email
    @amount = amount
    @link = ENV['FRONT_HOST'] + '/users/mes-euros'
    @reservation = reservation 
    @time = @reservation.time.strftime("%d/%m/%Y, à %H:%M")
    @restaurant = @reservation.restaurant
    mail to: @email, subject: "Félicitations, Vous avez été crédités par Happy Dining."
  end

  def confirmation_reminder user
    @user = user
    @email = user.email
    @unsubscribe_link = ENV['HOST'] + '/unsubscribe' + 
                        '?unsubscribe_token=' + 
                        user.confirmation_token.to_s +
                        '&user_id=' +
                        user.id.to_s

    mail to: @email, subject: "Confirmer votre compte"
  end
end
