class ApplicationController < ActionController::Base
  before_filter :require_login
  
  helper_method :current_user, :logged_in?
  
  protect_from_forgery with: :exception
  
  def current_user
    return unless session[:user_id]
    @current_user ||= User.find(session[:user_id])
  end
  
  def logged_in?
    !!current_user
  end
  
  private
    def require_login
      redirect_to root_path unless logged_in?
    end
  
end
