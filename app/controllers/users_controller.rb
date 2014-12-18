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

  def confirm
    user = User.find(params[:id])
    if user.confirmation_token == params[:token]
      user.update(confirmed_at: Time.now)
      redirect_to 'http://localhost:4200/confirm/success' 
    else
      redirect_to 'http://localhost:4200/confirm/fail' 
    end
  end
end

private
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation,
                                 :first_name, :last_name)
  end