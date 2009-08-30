class ApplicationController < ActionController::Base

  helper_method :current_user_session, :current_user, :page_user, :tabs

  # See ActionController::RequestForgeryProtection for details
  protect_from_forgery

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password, :password_confirmation

private

  def page
    params[:page] || 1
  end

  def per_page
    params[:per_page] || 20
  end

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end

  def page_user
    @page_user ||= if current_user.admin?
      User.find_by_id(params[:user_id] || params[:id]) || current_user
    else
      current_user
    end
  end

  def require_user
    unless current_user
      store_location
      redirect_to login_url
    end
  end

  def require_no_user
    if current_user
      store_location
      flash[:notice] = "You must be logged out to access that page."
      redirect_to home_url
    end
  end

  def require_admin
    redirect_to logout_url unless current_user.admin?
  end

  def store_location
    session[:return_to] = request.request_uri
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  def tabs
    @tabs ||= begin
      nav = []
      nav << ['My Gifts', gifts_path]
      nav << ['My Friends', user_friends_path(current_user)]
      nav << ['My Occasions', occasions_path]
      nav << ['My Reminders', reminders_path]
      nav << ['My Settings', edit_user_path(current_user)]
      nav << ['Users', users_path]
      nav << ['About', about_path]
      nav << ['Logout', logout_path]

      nav
    end
  end

end
