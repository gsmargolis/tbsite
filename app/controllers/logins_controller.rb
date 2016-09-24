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
      redirect_to user_path(user)
      #redirect_to "/summary"
    else
    # If user's login doesn't work, send them back to the login form.
      redirect_to '/login'
      flash[:danger] = "Incorrect Username or Password"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to '/login'
    flash[:success] = "You are logged out"
  end

end