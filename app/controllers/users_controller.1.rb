class UsersController < ApplicationController
  before_action :set_chef, only: [:edit, :update, :show]
  before_action :require_same_user, only: [:edit,
  
  def new
  end
  
  def create
    user = User.new(user_params)
    if user.save
      session[:user_id] = user.id
      redirect_to '/'
    else
      redirect_to '/register'
    end
  end
  
  
  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end


 :update]
  
  def index
    @chefs = Chef.paginate(page: params[:page], per_page: 3)
  end
  
  def new
    @chef = Chef.new
  end
  
  
  def create  #Curl>curlssl --insecure -X POST -H "Content-Type:application/json" -d "{\"chef\": {\"chefname\": \"blablabla\",\"email\": \"dummy@xxx.com\",\"password\": \"123456\"}}" https://recipemanager-gmargolis.c9users.io/chefs.json
    @chef = Chef.new(chef_params)
    p = params
    Rails.logger.debug p["gsmfield"]
    if @chef.save
      flash[:success] = "Your account was registered successfully"
      session[:chef_id] = @chef.id
      respond_to do |format|
        format.html { redirect_to recipes_path }
        format.json { render :json => @chef }
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
    if @chef.update(chef_params)
      flash[:success] = "Your profile was updated successfully"
      redirect_to chef_path(@chef)
    else
      render :edit
    end
  end

  def show
    @recipes = @chef.recipes.paginate(page: params[:page], per_page: 3)
  end

  private

    def chef_params
      params.require(:chef).permit(:chefname, :email, :password)
    end
    
    def set_user
      @user = User.find(params[:id])
    end
    def require_same_user
      if current_user != @chef
        flash[:danger] = "You can only edit your own profile"
        redirect_to root_path
      end
    end
   

end
