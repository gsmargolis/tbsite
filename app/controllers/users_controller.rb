class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :show]
  before_action :require_same_user, only: [:edit, :update]
  
  
  def index
    @users = User.all
  end
  
  def new
    @user = User.new
  end
  
  def create  #Curl>curlssl --insecure -X POST -H "Content-Type:application/json" -d "{\"chef\": {\"chefname\": \"blablabla\",\"email\": \"dummy@xxx.com\",\"password\": \"123456\"}}" https://recipemanager-gmargolis.c9users.io/chefs.json
    @user = User.new(user_params)
    p = params
    
    if @user.save
      flash[:success] = "Your account was registered successfully"
      session[:user_id] = @user.id
      respond_to do |format|
        format.html { redirect_to '/logout' }
      end
     # redirect_to recipes_path
    else
      respond_to do |format|
        format.html {render :new}
        format.json do 
          h = {"status" => "bad"}
          render :json => h 
        end
      end
      
    end
  
  end

  def edit
     
  end


  def update
    if @user.update(user_params)
      flash[:success] = "Your profile was updated successfully"
      redirect_to '/'
    else
      render :edit
    end
  end

  def show
    
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
        flash[:danger] = "You can only edit your own profile"
        redirect_to '/'
      end
    end
   

end
