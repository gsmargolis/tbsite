class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  helper_method :current_user, :logged_in?
  
  
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
    (@current_user != nil)? @current_player = Player.find_by(cbsid: @current_user.cbs_id) : nil
  end
  
  def logged_in?
    !!current_user
    
  end
  
  def require_user
    if !logged_in?
      #flash[:danger] = "You must be logged in to perform that action"
      redirect_to '/login'
    end
  end

end
