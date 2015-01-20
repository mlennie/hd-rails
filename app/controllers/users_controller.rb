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

    promotion = Promotion.check_presence params

    #delete promotion code from params
    params[:user].delete(:promotionCode)

    #build user
    user = User.new(user_params)

    #save user and add promotion if present
    if user.save_user_and_apply_promotion promotion
      render json: user, status: 201
    else
      render json: user.errors, status: 422
    end
  end

  def update
    #delete uneeded params
    params[:user].delete('wallet_id')
    params[:user].delete('gender')

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
      #can't get environment variables to work here ???
      if Rails.env.production?
        redirect_to 'https://hd-ember.herokuapp.com/login?confirmation_success=true'
      elsif Rails.env.staging?
        redirect_to 'https://hdemberstag.herokuapp.com/login?confirmation_success=true'
      elsif Rails.env.development?
        redirect_to 'http://localhost:4200/login?confirmation_success=true'
      end
    else
      #can't get environment variables to work here ???
      if Rails.env.production?
        redirect_to 'https://hd-ember.herokuapp.com/login?confirmation_fail=true'
      elsif Rails.env.staging?
        redirect_to 'https://hdemberstag.herokuapp.com/login?confirmation_fail=true'
      elsif Rails.env.development?
        redirect_to 'http://localhost:4200/login?confirmation_fail=true'
      end
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
    #can't get environment variables to work here ???
    if Rails.env.production?
      redirect_to "https://hd-ember.herokuapp.com/edit-password?token=#{reset_password_token}"
    elsif Rails.env.staging?
      redirect_to "https://hdemberstag.herokuapp.com/edit-password?token=#{reset_password_token}"
    elsif Rails.env.development?
      redirect_to "http://localhost:4200/edit-password?token=#{reset_password_token}"
    end
  end

  def update_password
    token = params[:password_reset_token]
    password = params[:password]
    password_confirmation = params[:password_confirmation]
    if (user = User.find_by(reset_password_token: token)) && 
      password.length >= 4 &&
      password === password_confirmation && user.reset_password_sent_at > 1.week.ago
      user.update(password: password)
      user.update(reset_password_token: nil)
      head 204
    else
      head 422
    end
  end

  private
  
    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation,
                                   :first_name, :last_name, :gender)
    end
end