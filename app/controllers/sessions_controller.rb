class SessionsController < ApplicationController

  before_filter(only: [:new, :create]) do
   redirect_to cats_url if signed_in?
  end

  def new

    render :new
  end

  def create
    user_name = params[:user][:user_name]
    password = params[:user][:password]
    @user = User.find_by_credentials(user_name, password)

    if @user.nil?
      render :new
    else
      sign_in!
      redirect_to cats_url
    end
  end


  def destroy
     @current_user = User.find_by(session_token: session[:session_token])
    session[:session_token] = nil
    @current_user.reset_session_token!
    redirect_to cats_url
  end


  private
  def session_params
    params.require(:user).permit(:user_name, :password)
  end

end
