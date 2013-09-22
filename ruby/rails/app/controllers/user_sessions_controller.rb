class UserSessionsController < ApplicationController

  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy

  # Login
  def create
    if user_session.save
      flash[:notice] = "Login successful!"
      redirect_back_or_default home_url
    else
      render :action => :new
    end
  end

  # Logout
  def destroy
    user_session.destroy
    flash[:notice] = "Logout successful!"
    redirect_to login_url
  end

end
