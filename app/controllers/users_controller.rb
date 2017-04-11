class UsersController < ApplicationController
  skip_before_filter :require_login, only: [:new, :create]

  def new
    @invitation = Invitation.find_by(token: params[:token])

    @user = User.new
    @user.email = @invitation.friend_email if @invitation
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)

    result = UserSignup.new(@user).sign_up(params[:stripeToken], params[:token])

    if result.successful?
      flash[:success] = "User has been created!"
      redirect_to login_path
    else
      flash[:danger] = result.error_message
      render :new
    end
  end

  private

    def user_params
      params.require(:user).permit(:username, :email, :password)
    end

end
