class UserSessionsController < ApplicationController

  before_action :require_no_user, :only => [:new, :create]
  before_action :require_user,    :only => :destroy

  def new
    add_ui_version_to_view_path(2)

    @user_session = UserSession.new
  end

  # Login
  def create
    add_ui_version_to_view_path(2)

    if user_session.save
      flash[:notice] = "Login successful!"
      redirect_back_or_default home_url
    else
      render :action => :new
    end
  end

  # Logout
  def destroy
    logout!
    flash[:notice] = "Logout successful!"
    redirect_to login_url
  end

  # Issue 110
  def clear_cookies
    session.clear
    logout!
    flash[:notice] = 'Your cookies have been cleared. Please try to log in again.'
    redirect_to login_url
  end

private

  def logout!
    user_session.destroy
  end

end
