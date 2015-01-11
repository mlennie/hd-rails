class UsersController < ApplicationController

  def show 
    user = User.includes(:wallet).find(params[:id])
    unless user.wallet.present?
      Wallet.create_for_user user
      user = User.includes(:wallet).find(params[:id])
    end
    render json: user, status: 200
  end

  def create
    user = User.new(user_params)
    if user.save
      render json: user, status: 201
    else
      render json: user.errors, status: 422
    end
  end

  def update
    user = User.find(params[:id])
    if user.update(user_params)
      render json: user, status: 200
    else
      render json: user.errors, status: 422
    end
  end

  def confirm
    user = User.find(params[:id])
    if user.confirmation_token == params[:token] && user.confirmed_at.blank?
      user.update(confirmed_at: Time.now)
      #can't get environment variables to work here ???
      if Rails.env.production?
        redirect_to 'http://hd-ember.herokuapp.com/login/confirmation_success'
      elsif Rails.env.staging?
        redirect_to 'http://hdemberstag.herokuapp.com/login/confirmation_success'
      elsif Rails.env.development?
        redirect_to 'http://localhost:4200/login/confirmation_success'
      end
    else
      #can't get environment variables to work here ???
      if Rails.env.production?
        redirect_to 'http://hd-ember.herokuapp.com/login/confirmation_fail'
      elsif Rails.env.staging?
        redirect_to 'http://hdemberstag.herokuapp.com/login/confirmation_fail'
      elsif Rails.env.development?
        redirect_to 'http://localhost:4200/login/confirmation_fail'
      end
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
      redirect_to "http://hd-ember.herokuapp.com/edit-password?token=#{reset_password_token}"
    elsif Rails.env.staging?
      redirect_to "http://hdemberstag.herokuapp.com/edit-password?token=#{reset_password_token}"
    elsif Rails.env.development?
      redirect_to "http://localhost:4200/edit-password?token=#{reset_password_token}"
    end
  end

  def update_password
    token = params[:password_reset_token]
    password = params[:password]
    password_confirmation = params[:password_confirmation]
    if (user = User.find_by(reset_password_token: token)) && 
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
                                   :first_name, :last_name)
    end
end