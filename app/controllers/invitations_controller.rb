class InvitationsController < ApplicationController
  def new 
    @invitation = Invitation.new
  end
  
  def create
    @invitation = Invitation.new(invitation_params)
    @invitation.inviter = current_user 
    
    if User.find_by(email: @invitation.friend_email)
      flash[:danger] = "This email address is already registered."
      redirect_to new_invitation_path
    elsif @invitation.save
      AppMailer.delay.send_invitation(@invitation)
      flash[:success] = "Invitation sent!"
      redirect_to new_invitation_path
    else 
      flash.now[:danger] = "Sorry invitation could not be sent. Please try again"
      render :new
    end
    
  end
  
  private 
  
    def invitation_params 
      params.require(:invitation).permit(:friend_name, :friend_email, :message)
    end
    
end