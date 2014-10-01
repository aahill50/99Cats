class UsersController < ApplicationController
  before_filter do
   redirect_to cats_url if signed_in?
  end



  def new
    @user = User.new
    render :new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      sign_in!
      redirect_to cats_url
    else
      render :new
      # add flash message for errors
    end
  end



  private

  def user_params
    params.require(:user).permit(:user_name, :password)
  end

end
