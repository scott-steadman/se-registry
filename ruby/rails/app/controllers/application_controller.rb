class ApplicationController < ActionController::Base

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Issue 11
  before_action :add_ui_version_to_view_path

  # Issue 11
  layout :select_layout

private

  # Issue 11
  def select_layout
    request.xhr? ? false : 'application'
  end

  def page
    params[:page] || 1
  end

  def per_page
    params[:per_page] || 20
  end

  helper_method :user_session
  def user_session
    @user_session ||= (UserSession.find || UserSession.new(user_session_params))
  end

  def user_session_params
    params.require(:user_session).permit(:login, :password).to_h rescue {}
  end

  helper_method :current_user
  def current_user
    return @current_user if defined?(@current_user)
    @current_user = user_session && user_session.record&.becomes(User)
  end

  helper_method :page_user
  def page_user
    @page_user ||= begin
      user_id = params[:user_id] || params[:id]

      if current_user.admin? and user_id
        User.find_by_id(user_id) || current_user
      else
        current_user
      end
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

  def store_location
    session[:return_to] = request.url
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  helper_method :logged_in?
  def logged_in?
    not user_session.record.nil?
  end

  # Issue 11
  def add_ui_version_to_view_path
    ui_version   = params[:ui_version]
    ui_version ||= current_user&.ui_version

    if ui_version
      prepend_view_path "app/views/v#{ui_version}"
    end
  end

end
