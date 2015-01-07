class UsersController < ApplicationController

  def show 
    user = User.find(params[:id])
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
      redirect_to 'http://hd-ember.herokuapp.com/login/confirmation_success' 
    else
      redirect_to 'http://hd-ember.herokuapp.com/login/confirmation_fail' 
    end
  end

  def password_email
    email = params[:email]
    if User.find_by(email: email).present? 
      user = User.find_by(email: email)
      UserMailer.password_reset(user).deliver
      head 200
    else
      head 422
    end
  end

  def change_password
    user = User.find(params[:user_id])
    reset_password_token = params[:reset_password_token]
    redirect_to "http://localhost:4200/users/edit-password?token=#{reset_password_token}"
  end

  private
  
    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation,
                                   :first_name, :last_name)
    end
end