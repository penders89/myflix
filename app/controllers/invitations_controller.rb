class InvitationsController < ApplicationController
  def new 
    @invitation = Invitation.new
  end
  
  def create
    @invitation = Invitation.new(invitation_params)
    @invitation.inviter = current_user 
    
    if @invitation.save
      AppMailer.send_invitation(@invitation).deliver
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