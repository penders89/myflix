class UsersController < ApplicationController
  skip_before_filter :require_login, only: [:new, :create]
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    
    if @user.save 
      flash[:success] = "User has been created"
      redirect_to login_path
    else 
      render :new
    end
  end
  
  private
  
    def user_params
      params.require(:user).permit(:username, :email, :password)
    end

end