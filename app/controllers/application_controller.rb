class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
   protect_from_forgery with: :exception

  def current_user
    return nil unless session[:session_token]
    @current_user ||= User.find_by(session_token: session[:session_token])
  end

  def signed_in?
    !!current_user
  end

  def require_current_user
    redirect_to new_session_url unless signed_in?
  end

  def sign_in!
    @user.reset_session_token!
    @user.save
    session[:session_token] = @user.session_token
  end

  helper_method :sign_in!
  helper_method :current_user
  helper_method :require_current_user
end
