module ApplicationHelper

  def possessivize(name)
    "#{name}'#{'s' if 's' != name[-1,1]}"
  end

  def sortable_column_header(title, column)
    dir = ("#{column} ASC" == order) ? 'DESC' : 'ASC'
    link_to title, url_for(:order => "#{column} #{dir}")
  end

end
