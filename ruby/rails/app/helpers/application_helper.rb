module ApplicationHelper

  def possessivize(name)
    "#{name}'#{'s' if 's' != name[-1,1]}"
  end

  def logged_in?
    not current_user_session.nil?
  end

end
