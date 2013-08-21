class ApplicationController < ActionController::Base

  helper_method :current_user_session, :current_user, :page_user, :tabs,
                :logged_in?

  # See ActionController::RequestForgeryProtection for details
  protect_from_forgery

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
    session[:return_to] = request.url
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  def logged_in?
    not current_user_session.nil?
  end

  def tabs
    @tabs ||= [
      ['My Gifts', gifts_path],
      ['My Friends', user_friends_path(current_user)],
      ['My Occasions', occasions_path],
      ['My Reminders', reminders_path],
      ['My Settings', edit_user_path(current_user)],
      ['Users', users_path],
      ['About', about_path],
      ['Logout', logout_path],
    ]
  end

  def role
    if current_user
      current_user.role.to_sym
    else
      :user
    end
  end

end
