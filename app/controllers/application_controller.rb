class ApplicationController < ActionController::Base
  helper_method :current_user
  helper_method :current_user_is_admin

  def ensure_that_signed_in
    redirect_to signin_path, notice: 'you should be signed in' if current_user.nil?
  end

  def current_user
    return nil if session[:user_id].nil?

    User.find(session[:user_id])
  end

  def current_user_is_admin
    current_user&.admin
  end

  def current_user_admin
    redirect_to signin_path, notice: 'operation allowed only for admins' unless current_user_is_admin
  end
end
