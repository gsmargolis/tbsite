class LoginsController < ApplicationController

  def new
  end

  def create
    user = User.find_by_email(params[:email])
    # If the user exists AND the password entered is correct.
    if user && user.authenticate(params[:password])
      # Save the user id inside the browser cookie. This is how we keep the user 
      # logged in when they navigate around our website.
      session[:user_id] = user.id
      if user.flag
        redirect_to "/summary"
      else
        user.flag = true
        user.save
        redirect_to user_path(user)
      end
      
    else
    # If user's login doesn't work, send them back to the login form.
      redirect_to '/login'
      if params[:email] == "tbowl"
        flash[:danger] = "The \"tbowl\" account is no longer available.\nPlease click the \"Create New Account\" link."
      else
        flash[:danger] = "Incorrect Username or Password"
      end
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to '/login'
    flash[:success] = "You are logged out"
  end

end