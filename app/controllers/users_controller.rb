class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :show, :nextwins]
  before_action :require_same_user, only: [:edit, :update]
  before_action :require_user
  
  
  def show

  end
  
  def index
    @users = User.all
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to '/logout'
    else
      render :new
    end
  
  end

  def edit
     
  end


  def nextwins
 
    @wins_needed = UsersHelper.get_wins_needed(params[:playerwins], params[:playergames], params[:leaderwins], params[:leadergames], params[:newwins], params[:nextweeksgames])

    respond_to do |format|
      format.js
    end

  end

  def update
    if @user.update(user_params)
      redirect_to '/'
    else
      render :edit
    end
  end


  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    
    def set_user
      @user = User.find(params[:id])
    end
    
    def require_same_user
      if current_user != @user
        redirect_to '/'
      end
    end
   

end
