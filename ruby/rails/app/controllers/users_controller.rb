class UsersController < ApplicationController

  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:edit, :home, :index, :show, :update, :destroy]
  before_filter :require_admin, :only => [:destroy]

  # GET /users
  # GET /users.xml
  def index
    conditions = current_user.admin? ? nil : ['id != ?', current_user.id]
    @users = User.paginate :page=>page, :per_page=>per_page, :order=>order
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])
    if request.post? && @user.save
      flash[:notice] = "Account registered!"
      redirect_back_or_default home_url
    else
      render :action => :new
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = page_user
  end

  # GET /users/1/edit
  def edit
    @user = page_user
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = page_user
    if request.put? && @user.update_attributes(params[:user])
      if params[:user] && current_user.admin?
        @user.role = params[:user][:role]
        @user.save
      end
      flash[:notice] = "Account updated!"
      redirect_back_or_default home_url
    else
      render :action => :edit
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    if request.delete?
      User.destroy(params[:id])
    end
    redirect_back_or_default users_url
  end

  def home
    store_location
  end

private

  def order
    'login'
  end

end
