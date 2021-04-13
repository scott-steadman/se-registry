class UsersController < ApplicationController

  before_action :require_no_user, :only => [:new, :create]
  before_action :require_user,    :only => [:edit, :home, :index, :show, :update, :destroy]

  # GET /users
  # GET /users.xml
  def index
    @users = User.order(order).paginate :page => page, :per_page => per_page
  end

  # GET /users/new
  def new
    @user = User::ForAuthentication.new
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User::ForAuthentication.new(user_params)

    if request.post? and @user.save
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

  # PATCH /users/1
  def update
    @user = page_user.becomes(User::ForAuthentication)
    if request.patch? and @user.update(user_params)
      if params[:user_for_authentication][:role] and current_user.admin?
        @user.role = params[:user_for_authentication][:role]
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
      if page_user.admin?
        flash[:error] = 'You cannot delete an admin account'
        redirect_back_or_default users_url
        return
      else
        page_user.destroy
      end
    end

    if closing_account?
      redirect_to logout_url
    else
      redirect_back_or_default users_url
    end
  end

  def home
    store_location
  end

private

  def order
    'login'
  end

  def closing_account?
    current_user == page_user
  end

  def user_params
    permitted = [:login, :email, :lead_time, :load_frequency, :notes, :password, :password_confirmation]
    params.require(:user_for_authentication).permit(permitted)
  end

end
