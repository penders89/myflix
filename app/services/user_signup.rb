class UserSignup
  attr_reader :error_message

  def initialize(user)
    @user = user
  end

  def sign_up(stripeToken, invitation_token)
    if @user.valid?
      charge = StripeWrapper::Charge.create(
        :amount => 999,
        :description => "Example charge",
        :source => stripeToken,
      )

      if charge.successful?
        @user.save

        invitation = Invitation.find_by(token: invitation_token)
        if invitation
          Relationship.create(leader: invitation.inviter, follower: @user)
          Relationship.create(leader: @user, follower: invitation.inviter)
        end
        AppMailer.send_welcome_email(@user).deliver
        @status = :success
        self
      else
        @status = :failed
        @error_message = charge.error_message
        self
      end
    else
      @status = :failed
      @error_message = "Invalid user information."
      self
    end
  end

  def successful?
    @status == :success
  end
end
