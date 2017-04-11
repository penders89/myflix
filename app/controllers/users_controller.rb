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
    invitation = Invitation.find_by(token: params[:token])

    if @user.valid?
      token = params[:stripeToken]
      charge = StripeWrapper::Charge.create(
        :amount => 999,
        :description => "Example charge",
        :source => token,
      )

      if charge.successful?
        @user.save

        if invitation
          Relationship.create(leader: invitation.inviter, follower: @user)
          Relationship.create(leader: @user, follower: invitation.inviter)
        end

        flash[:success] = "User has been created!"
        AppMailer.send_welcome_email(@user).deliver
        redirect_to login_path
      else
        flash[:danger] = charge.error_message
        render :new
      end
    else
      render :new
    end
  end

  private

    def user_params
      params.require(:user).permit(:username, :email, :password)
    end

end
