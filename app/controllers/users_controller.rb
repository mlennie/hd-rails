class UsersController < ApplicationController

  #GET /users/:id
  def show 
    user = User.check_wallet_and_include_associations params

    #authenticate and reply
    if user_signed_in? && user.id = current_user.id
      render json: user, status: 200
    else
      head 401
    end
  end

  def create

    #check whether user entered promotion or referral
    deal = Promotion.check_presence params
    unless deal.nil?
      if deal["kind"] === "promotion"
        promotion = deal["code"]
        referral = nil
      elsif deal["kind"] === "referral"
        promotion = nil
        referral_user_code = deal["code"]
      elsif deal["kind"] === "not valid"
        promotion = "bad code"
        referral = nil
      else
        promotion = nil
        referral = nil
      end
    else
      referred_user_code = params[:user][:referred_user_code]
    end

    #delete uneccessary params
    params[:user].delete(:promotion_code)
    params[:user].delete(:wallet_id)
    params[:user].delete(:referred_user_code)
    params[:user].delete(:referral_code)


    #build user
    user = User.new(user_params)

    #save user and add promotion if present
    if promotion != "bad code" && 
      user.save_user_and_apply_extras(promotion, referred_user_code)
      render json: user, status: 201
    else
      if promotion == "bad code" 
        errors = {
          errors: {
            code: "bad"
          }
        }
        render json: errors, status: 422
      else
        render json: user.errors, status: 422
      end
    end
  end

  def update
    #delete uneeded params
    params[:user].delete('wallet_id')

    user = User.find(params[:id])
    if user_signed_in? && user.id === current_user.id
      if user.update(user_params)
        render json: user, status: 200
      else
        render json: user.errors, status: 422
      end
    else
      head 401
    end
  end

  def resend_confirmation
    email = params[:email]
    if (user = User.find_by(email: email)) && user.confirmed_at.blank?
      Devise::Mailer.confirmation_instructions(user, user.confirmation_token).deliver
      head 204
    else
      head 422
    end
  end

  def confirm
    user = User.find(params[:id])
    if user.confirmation_token == params[:token] && user.confirmed_at.blank?
      user.update(confirmed_at: Time.now)
      redirect_to ENV['FRONT_HOST'] + '/login?confirmation_success=true'
    else
      redirect_to ENV['FRONT_HOST'] + '/login?confirmation_fail=true'
    end
  end

  #send password reset email
  def password_email
    email = params[:email]
    if User.find_by(email: email).present? 
      user = User.find_by(email: email)
      user.update_reset_password_token
      UserMailer.password_reset(user).deliver
      head 200
    else
      head 422
    end
  end

  def edit_password
    user = User.find(params[:user_id])
    reset_password_token = params[:password_reset_token]
    redirect_to ENV['FRONT_HOST'] + "/edit-password?token=#{reset_password_token}"
  end

  def update_password
    token = params[:password_reset_token]
    password = params[:password]
    password_confirmation = params[:password_confirmation]
    if (user = User.find_by(reset_password_token: token)) && 
      password.length >= 4 &&
      password === password_confirmation && user.reset_password_sent_at > 1.week.ago
      user.password = password
      user.reset_password_token = nil
      user.save(validate: false)
      head 204
    else
      head 422
    end
  end

  def unsubscribe
    confirmation_token = params[:unsubscribe_token]
    u = User.where(confirmation_token: confirmation_token).first
    if u.id == params[:user_id].to_i
      p = u.preferences
      p.receive_emails = false
      if p.save
        redirect_to ENV['FRONT_HOST'] + "/unsubscribed?unsubscription=success"
      else
        redirect_to ENV['FRONT_HOST'] + "/unsubscribed?unsubscription=fail"
      end
    else
      redirect_to ENV['FRONT_HOST'] + "/unsubscribed?unsubscription=fail"
    end
  end

  private
  
    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation,
                                   :first_name, :last_name, :gender)
    end
end