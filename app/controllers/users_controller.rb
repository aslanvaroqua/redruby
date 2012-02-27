class UsersController < ApplicationController
  # GET /users
  # GET /users.json
  before_filter :authenticate, :only => [:index, :edit, :update, :destroy] 
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user,   :only => :destroy

    def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.following.paginate(:page => params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(:page => params[:page])
    render 'show_follow'
  end

  def index
    @title = "All users"
    @users = User.paginate(:page => params[:page])
  end


  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(:page => params[:page])
    @title = @user.name
    
    end


  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new
    @title = "Sign up"

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
    @title = "Edit user"
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome!"
      redirect_to @user
    else
      @title = "Sign up"
      render 'new'
    end
  end



  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated."
      redirect_to @user
    else
      @title = "Edit user"
      render 'edit'
    end
  end


  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_path
  end
  

  
    private
    
     def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def authenticate
      deny_access unless signed_in?
    end
    
        def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
    

  
end 

