module ApplicationHelper

  def possessivize(name)
    "#{name}'#{'s' if 's' != name[-1,1]}"
  end

end
