class UsersController < ApplicationController

  def create
    user = User.new(user_params)
    if user.save
      render json: user, status: 201
    else
      render json: user.errors, status: 422
    end
  end
end

private
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation,
                                 :first_name, :last_name)
  end