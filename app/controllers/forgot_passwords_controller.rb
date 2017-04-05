class ForgotPasswordsController < ApplicationController
  skip_before_filter :require_login
  
  def create
    user = User.find_by(email: params[:email])
    
    if user
      AppMailer.delay.send_forgot_password(user)
      redirect_to forgot_password_confirmation_path
    else
      flash[:danger] = params[:email].blank? ? "Email cannot be blank." : "Email does not exist."
      redirect_to forgot_password_path
    end
  end

end