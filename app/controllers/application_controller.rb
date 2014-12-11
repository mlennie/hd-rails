class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def authenticate_admin_user!
    authenticate_user!
    unless current_user.is_superadmin?
      flash[:alert] = "Unauthorized Access!"
      redirect_to new_user_session_path
    end
  end
end
