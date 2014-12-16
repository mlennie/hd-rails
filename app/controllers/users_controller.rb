class UsersController < ApplicationController

  def create
    user = User.new(user_params)
    if user.save
      head 204
    else
      render json: user.errors, status: 422
    end
  end
end

private
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end